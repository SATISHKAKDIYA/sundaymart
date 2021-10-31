<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Brands;
use App\Models\Languages;
use App\Models\Shops;
use Illuminate\Http\Request;

class BrandController extends Controller
{
    public function save(Request $request)
    {
        $id = $request->id;
        $name = $request->name;
        $shop_id = $request->shop_id;
        $image_path = $request->image_path;
        $active = $request->active;
        $id_brand_category = $request->id_brand_category;

        if ($id > 0)
            $brand = Brands::findOrFail($id);
        else
            $brand = new Brands();

        $brand->name = $name;
        $brand->image_url = $image_path;
        $brand->active = $active;
        $brand->id_shop = $shop_id;
        $brand->id_brand_category = $id_brand_category;

        if ($id > 0)
            $brand->updated_at = date("Y-m-d H:i:s");
        else
            $brand->created_at = date("Y-m-d H:i:s");
        if ($brand->save()) {
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
        $totalData = Brands::count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');

        $defaultLanguage = Languages::where("default", 1)->first();

        if (empty($request->input('search'))) {
            $datas = Brands::select("brands.*", "shops_language.name as shop_name", "brand_categories_language.name as brand_category_name")
                ->join('shops_language', 'shops_language.id_shop', '=', 'brands.id_shop')
                ->join('brand_categories_language', 'brand_categories_language.id_brand_category', '=', 'brands.id_brand_category')
                ->where('shops_language.id_lang', $defaultLanguage->id)
                ->where('brand_categories_language.id_lang', $defaultLanguage->id)
                ->offset($start)
                ->limit($limit)
                ->get();
        } else {
            $search = $request->input('search');

            $datas = Brands::select("brands.*", "shops_language.name as shop_name", "brand_categories_language.name as brand_category_name")
                ->join('shops_language', 'shops_language.id_shop', '=', 'brands.id_shop')
                ->join('brand_categories_language', 'brand_categories_language.id_brand_category', '=', 'brands.id_brand_category')
                ->where('shops_language.id_lang', $defaultLanguage->id)
                ->where('brand_categories_language.id_lang', $defaultLanguage->id)
                ->where('name', 'LIKE', "%{$search}%")
                ->where('id', 'LIKE', "%{$search}%")
                ->offset($start)
                ->limit($limit)
                ->get();

            $totalFiltered = Brands::select("brands.*", "shops_language.name as shop_name", "brand_categories_language.name as brand_category_name")
                ->join('shops_language', 'shops_language.id_shop', '=', 'brands.id_shop')
                ->join('brand_categories_language', 'brand_categories_language.id_brand_category', '=', 'brands.id_brand_category')
                ->where('shops_language.id_lang', $defaultLanguage->id)
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
                $nestedData['shop'] = $data->shop_name;
                $nestedData['image_url'] = $data->image_url;
                $nestedData['active'] = $data->active;
                $nestedData['shop_name'] = $data->shop_name;
                $nestedData['brand_category_name'] = $data->brand_category_name;
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

        $brand = Brands::findOrFail($id);

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => $brand
        ]);
    }

    public function active(Request $request)
    {
        $shop_id = $request->shop_id;

        $brand = Brands::where([
            'id_shop' => $shop_id,
            'active' => 1
        ])->get();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => $brand
        ]);
    }

    public function delete(Request $request)
    {
        $id = $request->id;

        $brands = Brands::findOrFail($id);
        if ($brands) {
            $brands->delete();
        }

        return response()->json([
            'success' => 1,
            'msg' => "Successfully deleted"
        ]);
    }
}
