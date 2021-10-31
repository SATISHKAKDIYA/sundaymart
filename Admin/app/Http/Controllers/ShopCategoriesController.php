<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\ShopCategories;
use App\Models\ShopCategoriesLanguage;
use App\Models\Languages;


class ShopCategoriesController extends Controller
{
    public function save(Request $request)
    {
        $id = $request->id;
        $active = $request->active;
        $names = $request->name;

        if ($id > 0)
            $category = ShopCategories::findOrFail($id);
        else
            $category = new ShopCategories();

        $category->active = $active;
        if ($id > 0)
            $category->updated_at = date("Y-m-d H:i:s");
        else
            $category->created_at = date("Y-m-d H:i:s");

        if ($category->save()) {
            $shop_category_id = $category->id;
            foreach ($names as $key => $value) {

                $language = Languages::where("short_name", $key)->first();

                if ($id > 0) {
                    $shopCategoryLanguage = ShopCategoriesLanguage::where([
                        "id_shop_category" => $id,
                        "id_lang" => $language->id
                    ])->first();
                    if (!$shopCategoryLanguage)
                        $shopCategoryLanguage = new ShopCategoriesLanguage();
                } else
                    $shopCategoryLanguage = new ShopCategoriesLanguage();
                $shopCategoryLanguage->name = $value;
                $shopCategoryLanguage->id_shop_category = $shop_category_id;
                $shopCategoryLanguage->id_lang = $language->id;
                $shopCategoryLanguage->save();
            }

            return response()->json([
                'success' => 1,
                'msg' => "Successfully saved"
            ]);
        }

        return response()->json([
            'success' => 0,
            'msg' => "Error in saving language"
        ]);
    }

    public function datatable(Request $request)
    {
        $totalData = ShopCategories::count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');

        $defaultLanguage = Languages::where("default", 1)->first();

        if (empty($request->input('search'))) {
            $datas = ShopCategories::select("shop_categories.*", "shop_categories_language.name as name")
                ->join('shop_categories_language', 'shop_categories_language.id_shop_category', '=', 'shop_categories.id')
                ->where('shop_categories_language.id_lang', $defaultLanguage->id)
                ->offset($start)
                ->limit($limit)
                ->get();
        } else {
            $search = $request->input('search');

            $datas = ShopCategories::select("shop_categories.*", "shop_categories_language.name as name")
                ->join('shop_categories_language', 'shop_categories_language.id_shop_category', '=', 'shop_categories.id')
                ->where('shop_categories_language.id_lang', $defaultLanguage->id)
                ->where('name', 'LIKE', "%{$search}%")
                ->where('id', 'LIKE', "%{$search}%")
                ->offset($start)
                ->limit($limit)
                ->get();

            $totalFiltered = ShopCategories::select("shop_categories.*", "shop_categories_language.name as name")
                ->join('shop_categories_language', 'shop_categories_language.id_shop_category', '=', 'shop_categories.id')
                ->where('shop_categories_language.id_lang', $defaultLanguage->id)
                ->where('name', 'LIKE', "%{$search}%")
                ->where('id', 'LIKE', "%{$search}%")
                ->count();
        }

        $responseData = array();
        if (!empty($datas)) {
            foreach ($datas as $data) {

                $nestedData['id'] = $data->id;
                $nestedData['name'] = $data->name;
                $nestedData['active'] = $data->active;
                $nestedData['options'] = [
                    'delete' => 1,
                    'edit' => 1
                ];
                $responseData[] = $nestedData;

            }
        }

        $json_data = array(
            "total" => intval($totalData),
            "filtered" => intval($totalFiltered),
            "data" => $responseData
        );

        return response()->json($json_data);
    }


    public function get(Request $request)
    {
        $id = $request->id;
        $categories = ShopCategories::findOrFail($id);
        $categories_language = ShopCategoriesLanguage::select("shop_categories_language.*", "language.short_name")
            ->where("id_shop_category", $id)
            ->join('language', 'language.id', '=', 'shop_categories_language.id_lang')
            ->get();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => [
                "shop_category" => $categories,
                "shop_categories_language" => $categories_language
            ]
        ]);
    }

    public function delete(Request $request)
    {
        $id = $request->id;

        $categories = ShopCategories::findOrFail($id);
        if ($categories) {
            $categories->delete();
        }

        return response()->json([
            'success' => 1,
            'msg' => "Successfully deleted"
        ]);
    }

    public function active(Request $request)
    {
        $defaultLanguage = Languages::where("default", 1)->first();

        $categories = ShopCategories::select("shop_categories.id", "shop_categories_language.name")
            ->join('shop_categories_language', 'shop_categories_language.id_shop_category', '=', 'shop_categories.id')
            ->where([
                'shop_categories_language.id_lang' => $defaultLanguage->id,
                'shop_categories.active' => 1
            ])
            ->get();

        $categoriesArra = [];

        foreach ($categories as $category) {
            $categoriesArra[] = [
                'id' => $category->id,
                'name' => $category->name,
            ];
        }

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => $categoriesArra
        ]);
    }


}
