<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Languages;
use App\Models\Units;
use App\Models\UnitsLanguage;
use Illuminate\Http\Request;

class UnitController extends Controller
{
    public function save(Request $request)
    {
        $id = $request->id;
        $names = $request->name;
        $active = $request->active;

        if ($id > 0)
            $unit = Units::findOrFail($id);
        else
            $unit = new Units();
        $unit->active = $active;
        if ($unit->save()) {
            $unit_id = $unit->id;
            foreach ($names as $key => $value) {
                $language = Languages::where("short_name", $key)->first();

                if ($id > 0) {
                    $unitLanguage = UnitsLanguage::where([
                        "id_unit" => $id,
                        "id_lang" => $language->id
                    ])->first();
                    if (!$unitLanguage)
                        $unitLanguage = new UnitsLanguage();
                } else
                    $unitLanguage = new UnitsLanguage();
                $unitLanguage->name = $value;
                $unitLanguage->id_unit = $unit_id;
                $unitLanguage->id_lang = $language->id;
                $unitLanguage->save();
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
        $totalData = Units::count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');

        $defaultLanguage = Languages::where("default", 1)->first();

        if (empty($request->input('search'))) {
            $datas = Units::select("units.*", "units_language.name")
                ->join('units_language', 'units_language.id_unit', '=', 'units.id')
                ->where('units_language.id_lang', $defaultLanguage->id)
                ->offset($start)
                ->limit($limit)
                ->get();
        } else {
            $search = $request->input('search');

            $datas = Units::select("units.*", "units_language.name")
                ->join('units_language', 'units_language.id_unit', '=', 'units.id')
                ->where('units_language.id_lang', $defaultLanguage->id)
                ->where('name', 'LIKE', "%{$search}%")
                ->where('id', 'LIKE', "%{$search}%")
                ->offset($start)
                ->limit($limit)
                ->get();

            $totalFiltered = Units::select("units.*", "units_language.name")
                ->join('units_language', 'units_language.id_unit', '=', 'units.id')
                ->where('units_language.id_lang', $defaultLanguage->id)
                ->where('id', 'LIKE', "%{$search}%")
                ->where('name', 'LIKE', "%{$search}%")
                ->count();
        }

        $responseData = array();
        if (!empty($datas)) {
            foreach ($datas as $data) {
                $nestedData['id'] = $data->id;
                $nestedData['name'] = $data->name;
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
        $units = Units::findOrFail($id);
        $units_language = UnitsLanguage::select("units_language.*", "language.short_name")
            ->where("id_unit", $id)
            ->join('language', 'language.id', '=', 'units_language.id_lang')
            ->get();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => [
                "units" => $units,
                "units_language" => $units_language
            ]
        ]);
    }

    public function delete(Request $request)
    {
        $id = $request->id;

        $units = Units::findOrFail($id);
        if ($units) {
            $units->delete();
        }

        return response()->json([
            'success' => 1,
            'msg' => "Successfully deleted"
        ]);
    }

    public function active(Request $request) {
        $defaultLanguage = Languages::where("default", 1)->first();

        $units = Units::select("units.id", "units_language.name")
            ->join('units_language', 'units_language.id_unit', '=', 'units.id')
            ->where([
                'units_language.id_lang' => $defaultLanguage->id,
                'units.active' => 1,
            ])
            ->get();

        $unitsArra = [];

        foreach ($units as $unit) {
            $unitsArra[] = [
                'id' => $unit->id,
                'name' => $unit->name,
            ];
        }

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => $unitsArra
        ]);
    }
}
