<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\ShopPayment;
use App\Models\Languages;

class ShopPaymentController extends Controller
{
    public function save(Request $request)
    {
        $v = Validator::make($request->all(), [
            'id_shop' => 'required',
            'id_payment' => 'required'
        ]);

        if ($v->fails()) {
            return response()->json([
                'error' => 1,
                'msg' => $v->errors()
            ]);
        }

        $id = $request->id;
        $id_shop = $request->id_shop;
        $id_payment = $request->id_payment;

        if ($id > 0)
            $payment = ShopPayment::findOrFail($id);
        else
            $payment = new ShopPayment();

            $payment->id_shop = $id_shop;
            $payment->id_payment = $id_payment;

        if ($id > 0)
            $payment->updated_at = date("Y-m-d H:i:s");
        else
            $payment->created_at = date("Y-m-d H:i:s");

        if ($payment->save()) {
            return response()->json([
                'success' => 1,
                'msg' => "Successfully saved"
            ]);
        }

        return response()->json([
            'success' => 0,
            'msg' => "Error in saving payment"
        ]);
    }

    public function datatable(Request $request)
    {
        $totalData = ShopPayment::count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');

        $defaultLanguage = Languages::where("default", 1)->first();

        if (empty($request->input('search'))) {
            $datas = ShopPayment::select("shop_payment.*", "shops_language.name as shop_name", "payment_language.name as payment_name")
                ->join('payment_language', 'payment_language.id_payment', '=', 'shop_payment.id_payment')
                ->join('shops_language', 'shops_language.id_shop', '=', 'shop_payment.id_shop')
                ->where('payment_language.id_lang', $defaultLanguage->id)
                ->where('shops_language.id_lang', $defaultLanguage->id)
                ->offset($start)
                ->limit($limit)
                ->get();
        } else {
            $search = $request->input('search');

            $datas = ShopPayment::select("shop_payment.*", "shops_language.name as shop_name", "payment_language.name as payment_name")
                ->join('payment_language', 'payment_language.id_payment', '=', 'shop_payment.id_payment')
                ->join('shops_language', 'shops_language.id_shop', '=', 'shop_payment.id_shop')
                ->where('payment_language.id_lang', $defaultLanguage->id)
                ->where('shops_language.id_lang', $defaultLanguage->id)
                ->where('payment_language.name', 'LIKE', "%{$search}%")
                ->where('shops_language.name', 'LIKE', "%{$search}%")
                ->offset($start)
                ->limit($limit)
                ->get();

            $totalFiltered = ShopPayment::select("shop_payment.*", "shops_language.name as shop_name", "payment_language.name as payment_name")
                    ->join('payment_language', 'payment_language.id_payment', '=', 'shop_payment.id_payment')
                    ->join('shops_language', 'shops_language.id_shop', '=', 'shop_payment.id_shop')
                    ->where('payment_language.id_lang', $defaultLanguage->id)
                    ->where('shops_language.id_lang', $defaultLanguage->id)
                    ->where('payment_language.name', 'LIKE', "%{$search}%")
                    ->where('shops_language.name', 'LIKE', "%{$search}%")
                    ->offset($start)
                    ->limit($limit)
                    ->count();
        }

        $responseData = array();
        if (!empty($datas)) {
            foreach ($datas as $data) {

                $nestedData['id'] = $data->id;
                $nestedData['shop_name'] = $data->shop_name;
                $nestedData['payment_name'] = $data->payment_name;
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

        $payment = ShopPayment::select("shop_payment.*")
                    ->where('shop_payment.id', $id)
                    ->first();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => $payment
        ]);

    }

    public function delete(Request $request)
    {
        $id = $request->id;

        $payment = ShopPayment::findOrFail($id);
        if ($payment) {
            $payment->delete();
        }

        return response()->json([
            'success' => 1,
            'msg' => "Successfully deleted"
        ]);
    }
}
