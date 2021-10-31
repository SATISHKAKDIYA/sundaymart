<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\BrandCategories;
use App\Models\BrandCategoriesLanguage;
use App\Models\Languages;

class BrandCategoriesController extends Controller
{
    public function save(Request $request)
    {
        $id = $request->id;
        $active = $request->active;
        $names = $request->name;

        if ($id > 0)
            $category = BrandCategories::findOrFail($id);
        else
            $category = new BrandCategories();

        $category->active = $active;
        if ($id > 0)
            $category->updated_at = date("Y-m-d H:i:s");
        else
            $category->created_at = date("Y-m-d H:i:s");

        if ($category->save()) {
            $brand_category_id = $category->id;
            foreach ($names as $key => $value) {

                $language = Languages::where("short_name", $key)->first();

                if ($id > 0) {
                    $brandCategoryLanguage = BrandCategoriesLanguage::where([
                        "id_brand_category" => $id,
                        "id_lang" => $language->id
                    ])->first();
                    if (!$brandCategoryLanguage)
                        $brandCategoryLanguage = new BrandCategoriesLanguage();
                } else
                    $brandCategoryLanguage = new BrandCategoriesLanguage();
                $brandCategoryLanguage->name = $value;
                $brandCategoryLanguage->id_brand_category = $brand_category_id;
                $brandCategoryLanguage->id_lang = $language->id;
                $brandCategoryLanguage->save();
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
        $totalData = BrandCategories::count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');

        $defaultLanguage = Languages::where("default", 1)->first();

        if (empty($request->input('search'))) {
            $datas = BrandCategories::select("brand_categories.*", "brand_categories_language.name as name")
                ->join('brand_categories_language', 'brand_categories_language.id_brand_category', '=', 'brand_categories.id')
                ->where('brand_categories_language.id_lang', $defaultLanguage->id)
                ->offset($start)
                ->limit($limit)
                ->get();
        } else {
            $search = $request->input('search');

            $datas = BrandCategories::select("brand_categories.*", "brand_categories_language.name as name")
                ->join('brand_categories_language', 'brand_categories_language.id_brand_category', '=', 'brand_categories.id')
                ->where('brand_categories_language.id_lang', $defaultLanguage->id)
                ->where('name', 'LIKE', "%{$search}%")
                ->where('id', 'LIKE', "%{$search}%")
                ->offset($start)
                ->limit($limit)
                ->get();

            $totalFiltered = BrandCategories::select("brand_categories.*", "brand_categories_language.name as name")
                ->join('brand_categories_language', 'brand_categories_language.id_brand_category', '=', 'brand_categories.id')
                ->where('brand_categories_language.id_lang', $defaultLanguage->id)
                ->where('name', 'LIKE', "%{$search}%")
                ->where('id', 'LIKE', "%{$search}%")
                ->offset($start)
                ->limit($limit)
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
        $categories = BrandCategories::findOrFail($id);
        $categories_language = BrandCategoriesLanguage::select("brand_categories_language.*", "language.short_name")
            ->where("id_brand_category", $id)
            ->join('language', 'language.id', '=', 'brand_categories_language.id_lang')
            ->get();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => [
                "brand_category" => $categories,
                "brand_categories_language" => $categories_language
            ]
        ]);
    }

    public function delete(Request $request)
    {
        $id = $request->id;

        $categories = BrandCategories::findOrFail($id);
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

        $categories = BrandCategories::select("brand_categories.id", "brand_categories_language.name")
            ->join('brand_categories_language', 'brand_categories_language.id_brand_category', '=', 'brand_categories.id')
            ->where([
                'brand_categories_language.id_lang' => $defaultLanguage->id,
                'brand_categories.active' => 1
            ])
            ->get();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => $categories
        ]);
    }
}
