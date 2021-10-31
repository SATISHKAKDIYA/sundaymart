<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\PaymentsMethod;
use App\Models\PaymentsStatus;
use Illuminate\Http\Request;

class PaymentController extends Controller
{
    public function methodDatatable(Request $request)
    {
        $totalData = PaymentsMethod::count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');

        if (empty($request->input('search'))) {
            $datas = PaymentsMethod::offset($start)
                ->limit($limit)
                ->get();
        } else {
            $search = $request->input('search');

            $datas = PaymentsMethod::where('name', 'LIKE', "%{$search}%")
                ->where('id', 'LIKE', "%{$search}%")
                ->offset($start)
                ->limit($limit)
                ->get();

            $totalFiltered = PaymentsMethod::where('id', 'LIKE', "%{$search}%")
                ->where('name', 'LIKE', "%{$search}%")
                ->count();
        }

        $responseData = array();
        if (!empty($datas)) {
            foreach ($datas as $data) {
                $nestedData['id'] = $data->id;
                $nestedData['name'] = $data->name;
                $nestedData['active'] = $data->active;
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

    public function statusDatatable(Request $request)
    {
        $totalData = PaymentsStatus::count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');

        if (empty($request->input('search'))) {
            $datas = PaymentsStatus::offset($start)
                ->limit($limit)
                ->get();
        } else {
            $search = $request->input('search');

            $datas = PaymentsStatus::where('name', 'LIKE', "%{$search}%")
                ->where('id', 'LIKE', "%{$search}%")
                ->offset($start)
                ->limit($limit)
                ->get();

            $totalFiltered = PaymentsStatus::where('id', 'LIKE', "%{$search}%")
                ->where('name', 'LIKE', "%{$search}%")
                ->count();
        }

        $responseData = array();
        if (!empty($datas)) {
            foreach ($datas as $data) {
                $nestedData['id'] = $data->id;
                $nestedData['name'] = $data->name;
                $nestedData['active'] = $data->active;
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

    public function activeStatus()
    {
        $paymentStatus = PaymentsStatus::where([
            "active" => 1
        ])->get();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => $paymentStatus
        ]);
    }

    public function activeMethod()
    {
        $paymentMethod = PaymentsMethod::where([
            "active" => 1
        ])->get();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => $paymentMethod
        ]);
    }
}
