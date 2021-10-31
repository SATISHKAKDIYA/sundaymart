<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\Payments;
use App\Models\PaymentLanguage;
use App\Models\Languages;

class PaymentsController extends Controller
{
    public function save(Request $request)
    {
        $v = Validator::make($request->all(), [
            'active' => 'required',
            'name' => 'required|array'
        ]);

        if ($v->fails()) {
            return response()->json([
                'error' => 1,
                'msg' => $v->errors()
            ]);
        }

        $id = $request->id;
        $active = $request->active;
        $names = $request->name;

        if ($id > 0)
            $payment = Payments::findOrFail($id);
        else
            $payment = new Payments();

        $payment->active = $active;

        if ($id > 0)
            $payment->updated_at = date("Y-m-d H:i:s");
        else
            $payment->created_at = date("Y-m-d H:i:s");

        if ($payment->save()) {
            $payment_id = $payment->id;
            foreach ($names as $key => $value) {
                $language = Languages::where("short_name", $key)->first();

                if ($id > 0) {
                    $paymentLanguage = PaymentLanguage::where([
                        "id_payment" => $id,
                        "id_lang" => $language->id
                    ])->first();
                    if (!$paymentLanguage)
                        $paymentLanguage = new PaymentLanguage();
                } else
                    $paymentLanguage = new PaymentLanguage();
                    $paymentLanguage->name = $value;
                    $paymentLanguage->id_payment = $payment_id;
                    $paymentLanguage->id_lang = $language->id;
                    $paymentLanguage->save();
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
        $totalData = Payments::count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');

        $defaultLanguage = Languages::where("default", 1)->first();

        if (empty($request->input('search'))) {
            $datas = Payments::select("payments.*", "payment_language.name as name")
                ->join('payment_language', 'payment_language.id_payment', '=', 'payments.id')
                ->where('active', 1)
                ->where('payment_language.id_lang', $defaultLanguage->id)
                ->offset($start)
                ->limit($limit)
                ->get();
        } else {
            $search = $request->input('search');

            $datas = Payments::select("payments.*", "payment_language.name as name")
                ->join('payment_language', 'payment_language.id_payment', '=', 'payments.id')
                ->where('active', 1)
                ->where('payment_language.id_lang', $defaultLanguage->id)
                ->where('payment_language.name', 'LIKE', "%{$search}%")
                ->offset($start)
                ->limit($limit)
                ->get();

            $totalFiltered = Payments::select("payments.*", "payment_language.name as name")
                    ->join('payment_language', 'payment_language.id_payment', '=', 'payments.id')
                    ->where('active', 1)
                    ->where('payment_language.id_lang', $defaultLanguage->id)
                    ->where('payment_language.name', 'LIKE', "%{$search}%")
                    ->offset($start)
                    ->limit($limit)
                    ->count();
        }

        $responseData = array();
        if (!empty($datas)) {
            foreach ($datas as $data) {

                $nestedData['id'] = $data->id;
                $nestedData['active'] = $data->active;
                $nestedData['name'] = $data->name;
                $nestedData['created_at'] = $data->created_at;
                $nestedData['updated_at'] = $data->updated_at;
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

        $payment = Payments::select("payments.*")
            ->where('payments.id', $id)
            ->where('active', 1)
            ->first();

        $paymentLanguage = PaymentLanguage::select("payment_language.name as name", "language.short_name")
            ->join('language', 'language.id', '=', 'payment_language.id_lang')
            ->where('payment_language.id_payment', $id)
            ->get();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => [
                "payment" => $payment,
                "payment_language" => $paymentLanguage
            ]
        ]);

    }


    public function delete(Request $request)
    {
        $id = $request->id;

        $payment = Payments::findOrFail($id);
        if ($payment) {
            $payment->delete();
        }

        return response()->json([
            'success' => 1,
            'msg' => "Successfully deleted"
        ]);
    }

    public function active() {
        $defaultLanguage = Languages::where("default", 1)->first();

        $payments = Payments::select("payments.id", "payment_language.name")
            ->join('payment_language', 'payment_language.id_payment', '=', 'payments.id')
            ->where([
                'payment_language.id_lang' => $defaultLanguage->id,
                'payments.active' => 1,
            ])
            ->get();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => $payments
        ]);
    }
}
