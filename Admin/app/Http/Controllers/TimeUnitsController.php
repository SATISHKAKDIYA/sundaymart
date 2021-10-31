<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Brands;
use App\Models\Languages;
use App\Models\Shops;
use App\Models\TimeUnits;
use Illuminate\Http\Request;

class TimeUnitsController extends Controller
{
    public function save(Request $request)
    {
        $id = $request->id;
        $name = $request->name;
        $shop_id = $request->shop_id;
        $sort = $request->sort;
        $active = $request->active;

        if ($id > 0)
            $timeUnit = TimeUnits::findOrFail($id);
        else
            $timeUnit = new TimeUnits();

        $timeUnit->name = $name;
        $timeUnit->sort = $sort;
        $timeUnit->active = $active;
        $timeUnit->id_shop = $shop_id;
        if ($id > 0)
            $timeUnit->updated_at = date("Y-m-d H:i:s");
        else
            $timeUnit->created_at = date("Y-m-d H:i:s");
        if ($timeUnit->save()) {
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
        $totalData = TimeUnits::count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');

        $defaultLanguage = Languages::where("default", 1)->first();

        if (empty($request->input('search'))) {
            $datas = TimeUnits::select("time_units.*", "shops_language.name as shop_name")
                ->join('shops_language', 'shops_language.id_shop', '=', 'time_units.id_shop')
                ->where('shops_language.id_lang', $defaultLanguage->id)
                ->offset($start)
                ->limit($limit)
                ->get();
        } else {
            $search = $request->input('search');

            $datas = TimeUnits::select("time_units.*", "shops_language.name as shop_name")
                ->join('shops_language', 'shops_language.id_shop', '=', 'time_units.id_shop')
                ->where('shops_language.id_lang', $defaultLanguage->id)
                ->where('name', 'LIKE', "%{$search}%")
                ->where('id', 'LIKE', "%{$search}%")
                ->offset($start)
                ->limit($limit)
                ->get();

            $totalFiltered = TimeUnits::select("time_units.*", "shops_language.name as shop_name")
                ->join('shops_language', 'shops_language.id_shop', '=', 'time_units.id_shop')
                ->where('id', 'LIKE', "%{$search}%")
                ->where('shops_language.id_lang', $defaultLanguage->id)
                ->where('name', 'LIKE', "%{$search}%")
                ->count();
        }

        $responseData = array();
        if (!empty($datas)) {
            foreach ($datas as $data) {
                $nestedData['id'] = $data->id;
                $nestedData['name'] = $data->name;
                $nestedData['shop'] = $data->shop_name;
                $nestedData['sort'] = $data->sort;
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

        $brand = TimeUnits::findOrFail($id);

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => $brand
        ]);
    }

    public function delete(Request $request)
    {
        $id = $request->id;

        $timeUnits = TimeUnits::findOrFail($id);
        if ($timeUnits) {
            $timeUnits->delete();
        }

        return response()->json([
            'success' => 1,
            'msg' => "Successfully deleted"
        ]);
    }

    public function active(Request $request)
    {
        $shop_id = $request->shop_id;

        $timeUnits = TimeUnits::where([
            "id_shop" => $shop_id,
            "active" => 1
        ])->get();
        return response()->json([
            'success' => 1,
            'msg' => "Success",
            "data" => $timeUnits
        ]);
    }
}
