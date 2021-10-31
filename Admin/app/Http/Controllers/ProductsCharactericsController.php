<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\ProductsCharacterics;
use App\Models\ProductsCharactericsLanguage;
use Illuminate\Support\Facades\Validator;
use App\Models\Languages;

class ProductsCharactericsController extends Controller
{
    public function save(Request $request)
    {
        $v = Validator::make($request->all(), [
            'id_product' => 'required|numeric',
            'active' => 'required',
            'key' => 'required|array',
            'value' => 'required|array',
            
        ]);

        if ($v->fails()) {
            return response()->json([
                'error' => 1,
                'msg' => $v->errors()
            ]);
        }

        $id = $request->id;
        $id_product = $request->id_product;
        $active = $request->active;
        $key = $request->key;
        $value = $request->value;

        if ($id > 0)
            $products_characterics = ProductsCharacterics::findOrFail($id);
        else
            $products_characterics = new ProductsCharacterics();

            $products_characterics->id_product = $id_product;
            $products_characterics->active = $active;

            if ($products_characterics->save()) {

                $products_characterics_id = $products_characterics->id;

                foreach ($value as $k => $v) {
                    $language = Languages::where("short_name", $k)->first();
    
                    if ($id > 0) {
                        $productsCharactericsLanguage = ProductsCharactericsLanguage::where([
                            "id_product_characteristic" => $id,
                            "id_lang" => $language->id
                        ])->first();
                        if (!$productsCharactericsLanguage)
                            $productsCharactericsLanguage = new ProductsCharactericsLanguage();
                    } else
                        $productsCharactericsLanguage = new ProductsCharactericsLanguage();
                        $productsCharactericsLanguage->id_product_characteristic = $products_characterics_id;
                        $productsCharactericsLanguage->id_lang = $language->id;
                        $productsCharactericsLanguage->key = $key[$k];
                        $productsCharactericsLanguage->value = $v;
                        $productsCharactericsLanguage->save();
                    
                }

            return response()->json([
                'success' => 1,
                'msg' => "Successfully saved"
            ]);
        }

        return response()->json([
            'success' => 0,
            'msg' => "Error in saving"
        ]);
    }

    public function datatable(Request $request)
    {
        $v = Validator::make($request->all(), [
            'id_product' => 'required|numeric',
        ]);

        if ($v->fails()) {
            return response()->json([
                'error' => 1,
                'msg' => $v->errors()
            ]);
        }

        $totalData = ProductsCharacterics::count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');
        $id_product = $request->input('id_product');
        
        $defaultLanguage = Languages::where("default", 1)->first();
        
        if (empty($request->input('search'))) {

            $datas = ProductsCharacterics::select("products_characterics.*", "products_characterics_language.key", "products_characterics_language.value")->offset($start)
            ->join('products_characterics_language', 'products_characterics_language.id_product_characteristic', '=', 'products_characterics.id')
            ->where('products_characterics_language.id_lang', $defaultLanguage->id)
            ->where('products_characterics.id_product', $id_product)
            ->offset($start)
            ->limit($limit)
            ->get();

        } else {
            $search = $request->input('search');

            $datas = ProductsCharacterics::select("products_characterics.*", "products_characterics_language.key", "products_characterics_language.value")
                ->join('products_characterics_language', 'products_characterics_language.id_product_characteristic', '=', 'products_characterics.id')
                ->where('products_characterics_language.id_lang', $defaultLanguage->id)
                ->where('products_characterics.id_product', $id_product)
                ->where('products_characterics_language.key', 'LIKE', "%{$search}%")
                ->where('products_characterics_language.value', 'LIKE', "%{$search}%")
                ->offset($start)
                ->limit($limit)
                ->get();

            $totalFiltered = ProductsCharacterics::select("products_characterics.*", "products_characterics_language.key", "products_characterics_language.value")
                ->join('products_characterics_language', 'products_characterics_language.id_product_characteristic', '=', 'products_characterics.id')
                ->where('products_characterics_language.id_lang', $defaultLanguage->id)
                ->where('products_characterics.id_product', $id_product)
                ->where('products_characterics_language.key', 'LIKE', "%{$search}%")
                ->where('products_characterics_language.value', 'LIKE', "%{$search}%")
                ->offset($start)
                ->limit($limit)
                ->count();
        }

        $responseData = array();
        if (!empty($datas)) {
            foreach ($datas as $data) {

                $nestedData['id'] = $data->id;
                $nestedData['active'] = $data->active;
                $nestedData['key'] = $data->key;
                $nestedData['value'] = $data->value;
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

        $products_characterics = ProductsCharacterics::findOrFail($id);

        $products_characterics_language = ProductsCharactericsLanguage::select("products_characterics_language.*", "language.short_name")
            ->join('language', 'language.id', '=', 'products_characterics_language.id_lang')
            ->where('id_product_characteristic', $id)
            ->get();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => [
                "products_characterics" => $products_characterics,
                "products_characterics_language" => $products_characterics_language
            ]
        ]);

    }

    public function delete(Request $request)
    {
        $id = $request->id;

        $products_characterics = ProductsCharacterics::findOrFail($id);
        if ($products_characterics) {
            $products_characterics->delete();
        }

        return response()->json([
            'success' => 1,
            'msg' => "Successfully deleted"
        ]);
    }
}
