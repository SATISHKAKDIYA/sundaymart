<?php

namespace App\Http\Controllers;

use App\Models\Languages;
use Illuminate\Http\Request;

use App\Models\ShopsCurriencies;
use App\Models\Currency;
use App\Models\Shops;
use App\Models\Products;




class ShopsCurrienciesController extends Controller
{
    public function save(Request $request)
    {
        $id = $request->id;
        $shop_id = $request->shop_id;
        $currency_id = $request->currency_id;
        $default = $request->default;
        $value = $request->value;

        if ($id > 0)
            $shops_currency = ShopsCurriencies::findOrFail($id);
        else
            $shops_currency = new ShopsCurriencies();

            $shops_currency->id_shop = $shop_id;
            $shops_currency->id_currency = $currency_id;
            $shops_currency->default = $default;
            $shops_currency->value = $value;

        if ($id > 0)
            $shops_currency->updated_at = date("Y-m-d H:i:s");
        else
            $shops_currency->created_at = date("Y-m-d H:i:s");

        if ($shops_currency->save()) {

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
        $totalData = ShopsCurriencies::count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');

        $defaultLanguage = Languages::where("default", 1)->first();

        if (empty($request->input('search'))) {

            $datas = ShopsCurriencies::select("shops_curriencies.*", "shops_language.name as shop_name", "currency.id as currency_id", "currency_language.name as currency_name")
                ->join('shops_language', 'shops_language.id_shop', '=', 'shops_curriencies.id_shop')
                ->join('currency', 'currency.id', '=', 'shops_curriencies.id_currency')
                ->join('currency_language', 'currency_language.id_currency', '=', 'currency.id')
                ->where('shops_language.id_lang', $defaultLanguage->id)
                ->where('currency_language.id_lang', $defaultLanguage->id)
                ->offset($start)
                ->limit($limit)
                ->get();

        } else {
            $search = $request->input('search');

            $datas = ShopsCurriencies::select("shops_curriencies.*", "shops_language.name as shop_name", "currency.id as currency_id", "currency_language.name as currency_name")
                ->join('shops_language', 'shops_language.id_shop', '=', 'shops_curriencies.id_shop')
                ->join('currency', 'currency.id', '=', 'shops_curriencies.id_currency')
                ->join('currency_language', 'currency_language.id_currency', '=', 'currency.id')
                ->where('shops_language.name', 'LIKE', "%{$search}%")
                ->where('currency_language.name', 'LIKE', "%{$search}%")
                ->where('shops_language.id_lang', $defaultLanguage->id)
                ->where('currency_language.id_lang', $defaultLanguage->id)
                ->offset($start)
                ->limit($limit)
                ->get();


            $totalFiltered = ShopsCurriencies::select("shops_curriencies.*", "shops_language.name as shop_name", "currency.id as currency_id", "currency_language.name as currency_name")
                    ->join('shops_language', 'shops_language.id_shop', '=', 'shops_curriencies.id_shop')
                    ->join('currency', 'currency.id', '=', 'shops_curriencies.id_currency')
                    ->join('currency_language', 'currency_language.id_currency', '=', 'currency.id')
                    ->where('shops_language.name', 'LIKE', "%{$search}%")
                    ->where('currency_language.name', 'LIKE', "%{$search}%")
                    ->where('shops_language.id_lang', $defaultLanguage->id)
                    ->where('currency_language.id_lang', $defaultLanguage->id)
                    ->offset($start)
                    ->limit($limit)
                    ->count();
        }

        $responseData = array();
        if (!empty($datas)) {
            foreach ($datas as $data) {

                $nestedData['id'] = $data->id;
                $nestedData['shop_name'] = $data->shop_name;
                $nestedData['currency_name'] = $data->currency_name;
                $nestedData['default'] = $data->default;
                $nestedData['id_shop'] = $data->id_shop;

                $currency = ShopsCurriencies::select("currency.symbol")
                    ->join('currency', 'currency.id', '=', 'shops_curriencies.id_currency')
                    ->where('shops_curriencies.default', 1)
                    ->where('shops_curriencies.id_shop', $data->id_shop)
                    ->first();

                $nestedData['value'] = $data->value." ".$currency->symbol;

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



    // api function to get default shop currency by shop_id
    public function currency(Request $request)
    {
        $id_shop = $request->shop_id;

        $shops_currency = ShopsCurriencies::select("shops_curriencies.*", "currency.*")
                ->join('currency', 'currency.id', '=', 'shops_curriencies.id_currency')
                ->where('shops_curriencies.id_shop', $id_shop)
                ->where('shops_curriencies.default', 1)
                ->first();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => $shops_currency
        ]);

    }

    public function get(Request $request)
    {
        $id = $request->id;

        $shops_currency = ShopsCurriencies::select("shops_curriencies.*")
                ->where('shops_curriencies.id', $id)
                ->first();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => $shops_currency
        ]);
    }

    public function delete(Request $request)
    {
        $id = $request->id;

        $shops_currency = ShopsCurriencies::findOrFail($id);
        if ($shops_currency) {
            $shops_currency->delete();
        }

        return response()->json([
            'success' => 1,
            'msg' => "Successfully deleted"
        ]);
    }

	public function change(Request $request){
        $id = $request->id_shop_currency;
        $id_shop = $request->shop_id;

        // change default to 0
        $shops_currency = ShopsCurriencies::where('id_shop', $id_shop)
                ->where('default', 1)
                ->first();

        $shops_currency->default = 0;
        $shops_currency->save();

        // change default to 1
        $shops_currency = ShopsCurriencies::where('id_shop', $id_shop)
                ->where('id', $id)
                ->first();

        $default_value = $shops_currency->value;

        $shops_currency->default = 1;
        $shops_currency->value = 1;
        $shops_currency->save();

        $shops = ShopsCurriencies::where('id_shop', $id_shop)
                ->where('id', '<>', $id)
                ->get();

        foreach($shops as $single_shop){
            $shop = ShopsCurriencies::findOrFail($single_shop->id);

            $shop->value = $shop->value / $default_value;
            $shop->save();
        }

//        $products = Products::where('id_shop', $id_shop)->get();
//
//        foreach($products as $single_product){
//
//            $price = $single_product->price / $default_value;
//            $product = Products::findOrFail($single_product->id);
//            $product->value = $price;
//            $product->save();
//        }

        return response()->json([
            'success' => 1,
            'msg' => "Success"
        ]);
    }
}
