<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Coupon;
use App\Models\CouponLanguage;
use App\Models\CouponProducts;
use App\Models\Languages;
use App\Models\Admin;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class CouponController extends Controller
{
    public function save(Request $request)
    {
        $name = $request->name;
        $description = $request->description;
        $active = $request->active;
        $shop_id = $request->shop_id;
        $id = $request->id;
        $discount_type = $request->discount_type;
        $discount = $request->discount;
        $usage_time = $request->usage_time;
        $valid = $request->valid;
        $products = $request->products;

        if ($id > 0)
            $coupon = Coupon::findOrFail($id);
        else
            $coupon = new Coupon();

        $coupon->name = $name;
        $coupon->discount_type = $discount_type;
        $coupon->discount = $discount;
        $coupon->usage_time = $usage_time;
        $coupon->valid_until = date("Y-m-d H:i:s", strtotime($valid));
        $coupon->active = $active;
        $coupon->id_shop = $shop_id;

        if ($id > 0)
            $coupon->updated_at = date("Y-m-d H:i:s");
        else
            $coupon->created_at = date("Y-m-d H:i:s");

        if ($coupon->save()) {
            $coupon_id = $coupon->id;

            foreach ($description as $key => $value) {
                $language = Languages::where("short_name", $key)->first();

                if ($id > 0) {
                    $couponLanguage = CouponLanguage::where([
                        "id_coupon" => $id,
                        "id_lang" => $language->id
                    ])->first();
                    if (!$couponLanguage)
                        $couponLanguage = new CouponLanguage();
                } else
                    $couponLanguage = new CouponLanguage();
                $couponLanguage->description = $value;
                $couponLanguage->id_coupon = $coupon_id;
                $couponLanguage->id_lang = $language->id;
                $couponLanguage->save();
            }

            CouponProducts::where("id_coupon", $coupon_id)->delete();

            if ($products && count($products) > 0)
                foreach ($products as $product) {
                    $couponProduct = new CouponProducts();
                    $couponProduct->id_coupon = $coupon_id;
                    $couponProduct->id_product = $product;
                    $couponProduct->save();
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
        $totalData = Coupon::count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');

        $defaultLanguage = Languages::where("default", 1)->first();
        $shop_id = Admin::getUserShopId();

        if (empty($request->input('search'))) {
            $datas = Coupon::select("coupon.*",
                "coupon_language.description",
                'shops_language.name as shop_name')
                ->join('coupon_language', 'coupon_language.id_coupon', '=', 'coupon.id')
                ->join('shops_language', 'shops_language.id_shop', '=', 'coupon.id_shop')
                ->where('coupon_language.id_lang', $defaultLanguage->id)
                ->where('shops_language.id_lang', $defaultLanguage->id);
                if($shop_id != -1){
                    $datas = $datas->where('coupon.id_shop', $shop_id);
                 }

                 $datas = $datas
                ->offset($start)
                ->limit($limit)
                ->get();
        } else {
            $search = $request->input('search');

            $datas = Coupon::select("coupon.*",
                "coupon_language.description",
                'shops_language.name as shop_name')
                ->join('coupon_language', 'coupon_language.id_coupon', '=', 'coupon.id')
                ->join('shops_language', 'shops_language.id_shop', '=', 'coupon.id_shop')
                ->where('coupon_language.id_lang', $defaultLanguage->id)
                ->where('shops_language.id_lang', $defaultLanguage->id)
                ->where('name', 'LIKE', "%{$search}%")
                ->where('id', 'LIKE', "%{$search}%");
                if($shop_id != -1){
                    $datas = $datas->where('coupon.id_shop', $shop_id);
                 }

                 $datas = $datas
                ->offset($start)
                ->limit($limit)
                ->get();

            $totalFiltered = Coupon::select("coupon.*",
                "coupon_language.description",
                'shops_language.name as shop_name')
                ->join('coupon_language', 'coupon_language.id_coupon', '=', 'coupon.id')
                ->join('shops_language', 'shops_language.id_shop', '=', 'coupon.id_shop')
                ->where('coupon_language.id_lang', $defaultLanguage->id)
                ->where('shops_language.id_lang', $defaultLanguage->id)
                ->where('id', 'LIKE', "%{$search}%")
                ->where('name', 'LIKE', "%{$search}%");
                if($shop_id != -1){
                    $datas = $datas->where('coupon.id_shop', $shop_id);
                 }

                 $datas = $datas
                ->count();
        }

        $responseData = array();
        if (!empty($datas)) {
            foreach ($datas as $data) {
                $nestedData['id'] = $data->id;
                $nestedData['name'] = $data->name;
                $nestedData['description'] = $data->description;
                $nestedData['shop'] = $data->shop_name;
                $nestedData['discount_type'] = $data->discount_type;
                $nestedData['discount'] = $data->discount;
                $nestedData['usage_time'] = $data->usage_time;
                $nestedData['valid_until'] = $data->valid_until;
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

    public function delete(Request $request)
    {
        $id = $request->id;
        $coupon = Coupon::find($id);
        if ($coupon) {
            $coupon->delete();
        }

        return response()->json([
            'success' => 1,
            'msg' => "Successfully deleted"
        ]);
    }


    public function get(Request $request)
    {
        $id = $request->id;
        $coupon = Coupon::findOrFail($id);
        $coupon_language = CouponLanguage::select("coupon_language.*", "language.short_name")->where("id_coupon", $id)
            ->join('language', 'language.id', '=', 'coupon_language.id_lang')
            ->get();

        $coupon_products = CouponProducts::select("coupon_products.*")->where("id_coupon", $id)
            ->get();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => [
                "coupon" => $coupon,
                "coupon_language" => $coupon_language,
                'coupon_products' => $coupon_products
            ]
        ]);
    }
}
