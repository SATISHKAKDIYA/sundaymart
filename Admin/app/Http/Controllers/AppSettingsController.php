<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Languages;
use App\Models\MobileParams;
use App\Models\MobileParamsLanguage;
use Illuminate\Http\Request;

class AppSettingsController extends Controller
{
    public function appLanguageDatatable(Request $request)
    {
        $totalData = Languages::count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');

        if (empty($request->input('search'))) {
            $datas = Languages::offset($start)
                ->limit($limit)
                ->get();
        } else {
            $search = $request->input('search');

            $datas = Languages::where('name', 'LIKE', "%{$search}%")
                ->where('id', 'LIKE', "%{$search}%")
                ->offset($start)
                ->limit($limit)
                ->get();

            $totalFiltered = Languages::where('id', 'LIKE', "%{$search}%")
                ->where('name', 'LIKE', "%{$search}%")
                ->count();
        }

        $responseData = array();
        if (!empty($datas)) {
            foreach ($datas as $data) {
                $params = MobileParams::count();
                $paramsLanguage = MobileParamsLanguage::where("id_lang", $data->id)->count();

                $nestedData['id'] = $data->id;
                $nestedData['language'] = $data->name;
                $nestedData['percentage'] = intval(($paramsLanguage * 100) / $params) . " %";
                $nestedData['options'] = [
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

    public function appLanguageDatatableWord(Request $request)
    {
        $totalData = MobileParams::count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');
        $id_lang = $request->input('id_lang');

        if (empty($request->input('search'))) {
            $datas = MobileParams::offset($start)
                ->limit($limit)
                ->get();
        } else {
            $search = $request->input('search');

            $datas = MobileParams::where('name', 'LIKE', "%{$search}%")
                ->where('id', 'LIKE', "%{$search}%")
                ->offset($start)
                ->limit($limit)
                ->get();

            $totalFiltered = MobileParams::where('id', 'LIKE', "%{$search}%")
                ->where('name', 'LIKE', "%{$search}%")
                ->count();
        }

        $responseData = array();
        if (!empty($datas)) {
            foreach ($datas as $data) {
                $paramsLang = MobileParamsLanguage::where([
                    'id_param' => $data->id,
                    'id_lang' => $id_lang
                ])->first();

                $nestedData['id'] = $data->id;
                $nestedData['word'] = $data->name;
                $nestedData['translation'] = $paramsLang ? $paramsLang->name : "";
                $nestedData['options'] = [
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

    public function save(Request $request)
    {
        $id_lang = $request->id_lang;
        $name = $request->name;
        $id_param = $request->id_param;

        $paramsLang = MobileParamsLanguage::where([
            'id_param' => $id_param,
            'id_lang' => $id_lang
        ])->first();

        if (!$paramsLang)
            $paramsLang = new MobileParamsLanguage();

        $paramsLang->id_param = $id_param;
        $paramsLang->id_lang = $id_lang;
        $paramsLang->name = $name;
        $paramsLang->save();

        return response()->json([
            'success' => 1,
            'msg' => "Success"
        ]);
    }
}
