<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Categories;
use App\Models\CategoriesLanguage;
use App\Models\Languages;
use App\Models\Shops;
use Illuminate\Http\Request;

class CategoryController extends Controller
{
    public function save(Request $request)
    {
        $id = $request->id;
        $names = $request->name;
        $shop_id = $request->shop_id;
        $parent = $request->parent;
        $image_path = $request->image_path;
        $active = $request->active;

        if ($id > 0)
            $category = Categories::findOrFail($id);
        else
            $category = new Categories();

        $category->parent = $parent;
        $category->image_url = $image_path;
        $category->active = $active;
        $category->id_shop = $shop_id;
        if ($id > 0)
            $category->updated_at = date("Y-m-d H:i:s");
        else
            $category->created_at = date("Y-m-d H:i:s");
        if ($category->save()) {
            $category_id = $category->id;
            foreach ($names as $key => $value) {
                $language = Languages::where("short_name", $key)->first();

                if ($id > 0) {
                    $categoryLanguage = CategoriesLanguage::where([
                        "id_category" => $id,
                        "id_lang" => $language->id
                    ])->first();
                    if (!$categoryLanguage)
                        $categoryLanguage = new CategoriesLanguage();
                } else
                    $categoryLanguage = new CategoriesLanguage();
                $categoryLanguage->name = $value;
                $categoryLanguage->id_category = $category_id;
                $categoryLanguage->id_lang = $language->id;
                $categoryLanguage->save();
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
        $totalData = Categories::count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');

        $defaultLanguage = Languages::where("default", 1)->first();

        if (empty($request->input('search'))) {
            $datas = Categories::select("categories.*", "shops_language.name as shop_name", "categories_language.name")
                ->join('shops_language', 'shops_language.id_shop', '=', 'categories.id_shop')
                ->join('categories_language', 'categories_language.id_category', '=', 'categories.id')
                ->where('shops_language.id_lang', $defaultLanguage->id)
                ->where('categories_language.id_lang', $defaultLanguage->id)
                ->offset($start)
                ->limit($limit)
                ->orderBy("categories.id","desc")
                ->get();
        } else {
            $search = $request->input('search');

            $datas = Categories::select("categories.*", "shops_language.name as shop_name", "categories_language.name")
                ->join('shops_language', 'shops_language.id_shop', '=', 'categories.id_shop')
                ->join('categories_language', 'categories_language.id_category', '=', 'categories.id')
                ->where('shops_language.id_lang', $defaultLanguage->id)
                ->where('categories_language.id_lang', $defaultLanguage->id)
                ->where('name', 'LIKE', "%{$search}%")
                ->where('id', 'LIKE', "%{$search}%")
                ->offset($start)
                ->limit($limit)
                ->get();

            $totalFiltered = Categories::select("categories.*", "shops_language.name as shop_name", "categories_language.name")
                ->join('shops_language', 'shops_language.id_shop', '=', 'categories.id_shop')
                ->join('categories_language', 'categories_language.id_category', '=', 'categories.id')
                ->where('shops_language.id_lang', $defaultLanguage->id)
                ->where('categories_language.id_lang', $defaultLanguage->id)
                ->where('id', 'LIKE', "%{$search}%")
                ->where('name', 'LIKE', "%{$search}%")
                ->count();
        }

        $responseData = array();
        if (!empty($datas)) {
            foreach ($datas as $data) {

                $nestedData['id'] = $data->id;
                $nestedData['name'] = $data->name;
                $nestedData['shop'] = $data->shop_name;
                if ($data->parent > 0) {
                    $category = Categories::select("categories.id", "categories_language.name")
                        ->join('categories_language', 'categories_language.id_category', '=', 'categories.id')
                        ->where([
                            'categories_language.id_lang' => $defaultLanguage->id,
                            'categories.id' => $data->parent,
                        ])
                        ->first();

                    $nestedData['parent'] = $category != null ? $category->name : "";
                } else
                    $nestedData['parent'] = "No parent category";

                $nestedData['image_url'] = $data->image_url;
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
        $categories = Categories::findOrFail($id);
        $categories_language = CategoriesLanguage::select("categories_language.*", "language.short_name")
            ->where("id_category", $id)
            ->join('language', 'language.id', '=', 'categories_language.id_lang')
            ->get();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => [
                "category" => $categories,
                "categories_language" => $categories_language
            ]
        ]);
    }

    public function delete(Request $request)
    {
        $id = $request->id;

        if (is_array($id)) {
            Categories::whereIn("id", $id)->delete();
        } else {
            $categories = Categories::findOrFail($id);
            if ($categories) {
                $categories->delete();
            }
        }

        return response()->json([
            'success' => 1,
            'msg' => "Successfully deleted"
        ]);
    }

    public function active(Request $request)
    {
        $shop_id = $request->shop_id;
        $defaultLanguage = Languages::where("default", 1)->first();

        $categories = Categories::select("categories.id", "categories_language.name")
            ->join('categories_language', 'categories_language.id_category', '=', 'categories.id')
            ->where([
                'categories_language.id_lang' => $defaultLanguage->id,
                'categories.active' => 1,
                'categories.id_shop' => $shop_id
            ])->where("categories.parent", "!=", -1)
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

    public function parent(Request $request)
    {
        $shop_id = $request->shop_id;
        $defaultLanguage = Languages::where("default", 1)->first();

        $categories = Categories::select("categories.id", "categories_language.name")
            ->join('categories_language', 'categories_language.id_category', '=', 'categories.id')
            ->where([
                'categories_language.id_lang' => $defaultLanguage->id,
                'categories.parent' => -1,
                'categories.active' => 1,
                'categories.id_shop' => $shop_id
            ])
            ->get();

        $categoriesArra = [
            [
                'id' => -1,
                'name' => 'No parent'
            ]
        ];

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
