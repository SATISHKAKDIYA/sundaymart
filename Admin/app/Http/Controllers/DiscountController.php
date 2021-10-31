<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\DiscountProducts;
use App\Models\Discount;
use App\Models\Languages;

class DiscountController extends Controller
{
    public function save(Request $request)
    {
        $v = Validator::make($request->all(), [
            'is_count_down' => 'required',
            'discount_type' => 'required',
            'discount_amount' => 'required',
            'id_shop' => 'required',
            'active' => 'required',
            'product_ids' => 'required|array|min:1',
        ]);

        if ($v->fails()) {
            return response()->json([
                'error' => 1,
                'msg' => $v->errors()
            ]);
        }

        $id = $request->id;
        $is_count_down = $request->is_count_down;
        $discount_type = $request->discount_type;
        $discount_amount = $request->discount_amount;
        $start_time = $request->start_time;
        $end_time = $request->end_time;
        $active = $request->active;
        $product_ids = $request->product_ids;
        $id_shop = $request->id_shop;

        if ($id > 0) {
            $discount = Discount::findOrFail($id);
            // delete all DiscountProducts
            DiscountProducts::where('id_discount', $id)->delete();
        } else {
            $discount = new Discount();
        }

        $discount->is_count_down = $is_count_down;
        $discount->discount_type = $discount_type;
        $discount->discount_amount = $discount_amount;
        $discount->start_time = date("Y-m-d H:i:s", strtotime($start_time));
        $discount->end_time = date("Y-m-d H:i:s", strtotime($end_time));
        $discount->active = $active;
        $discount->id_shop = $id_shop;

        if ($discount->save()) {
            foreach ($product_ids as $product_id) {
                $discount_product = new DiscountProducts();
                $discount_product->id_product = $product_id;
                $discount_product->id_discount = $discount->id;
                $discount_product->save();
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
        $totalData = Discount::count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');

        $defaultLanguage = Languages::where("default", 1)->first();

        if (empty($request->input('search'))) {
            $datas = Discount::select("discount.*", "shops_language.name as shop_name")
                ->join('shops_language', 'shops_language.id_shop', '=', 'discount.id_shop')
                ->where('active', 1)
                ->where('shops_language.id_lang', $defaultLanguage->id)
                ->offset($start)
                ->limit($limit)
                ->get();
        } else {
            $search = $request->input('search');

            $datas = Discount::select("discount.*", "shops_language.name as shop_name")
                ->join('shops_language', 'shops_language.id_shop', '=', 'discount.id_shop')
                ->where('active', 1)
                ->where('shops_language.id_lang', $defaultLanguage->id)
                ->where('discount_type', 'LIKE', "%{$search}%")
                ->where('discount_amount', 'LIKE', "%{$search}%")
                ->where('shops_language.name', 'LIKE', "%{$search}%")
                ->offset($start)
                ->limit($limit)
                ->get();


            $totalFiltered = Discount::select("discount.*", "shops_language.name as shop_name")
                ->join('shops_language', 'shops_language.id_shop', '=', 'discount.id_shop')
                ->where('active', 1)
                ->where('shops_language.id_lang', $defaultLanguage->id)
                ->where('discount_type', 'LIKE', "%{$search}%")
                ->where('discount_amount', 'LIKE', "%{$search}%")
                ->where('shops_language.name', 'LIKE', "%{$search}%")
                ->offset($start)
                ->limit($limit)
                ->count();
        }

        $responseData = array();
        if (!empty($datas)) {
            foreach ($datas as $data) {

                $nestedData['id'] = $data->id;
                $nestedData['is_count_down'] = $data->is_count_down;
                $nestedData['discount_type'] = $data->discount_type;
                $nestedData['discount_amount'] = $data->discount_amount;
                $nestedData['start_time'] = $data->start_time;
                $nestedData['end_time'] = $data->end_time;
                $nestedData['active'] = $data->active;
                $nestedData['shop_name'] = $data->shop_name;
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

        $defaultLanguage = Languages::where("default", 1)->first();

        $discount = Discount::findOrFail($id);
        $discount_products = DiscountProducts::select("discount_products.*", "products_language.name")
            ->join('products_language', 'products_language.id_product', '=', 'discount_products.id_product')
            ->where("discount_products.id_discount", $id)
            ->where("products_language.id_lang", $defaultLanguage->id)
            ->get();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => [
                "discount" => $discount,
                "discount_products" => $discount_products
            ]
        ]);

    }

    public function delete(Request $request)
    {
        $id = $request->id;

        $discount = Discount::findOrFail($id);
        if ($discount) {
            $discount->delete();
        }

        return response()->json([
            'success' => 1,
            'msg' => "Successfully deleted"
        ]);
    }
}
