<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\ExtrasGroupTypes;
use App\Models\Languages;
use App\Models\ProductExtrasGroup;
use App\Models\ProductExtrasGroupLanguage;
use Illuminate\Http\Request;

class ExtraGroupController extends Controller
{
    public function types(Request $request)
    {
        $extrasTypes = ExtrasGroupTypes::where("active", 1)->get();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => $extrasTypes
        ]);
    }

    public function save(Request $request)
    {
        $name = $request->name;
        $type = $request->type;
        $active = $request->active;
        $id = $request->id;
        $product_id = $request->product_id;

        if ($id > 0)
            $extrasGroup = ProductExtrasGroup::findOrFail($id);
        else
            $extrasGroup = new ProductExtrasGroup();

        $extrasGroup->id_product = $product_id;
        $extrasGroup->active = $active;
        $extrasGroup->type = $type;
        if ($extrasGroup->save()) {
            $extras_group_id = $extrasGroup->id;
            foreach ($name as $key => $value) {
                $language = Languages::where("short_name", $key)->first();

                if ($id > 0) {
                    $extrasGroupLanguage = ProductExtrasGroupLanguage::where([
                        "id_extra_group" => $id,
                        "id_lang" => $language->id
                    ])->first();
                    if (!$extrasGroupLanguage)
                        $extrasGroupLanguage = new ProductExtrasGroupLanguage();
                } else
                    $extrasGroupLanguage = new ProductExtrasGroupLanguage();

                $extrasGroupLanguage->name = $value;
                $extrasGroupLanguage->id_extra_group = $extras_group_id;
                $extrasGroupLanguage->id_lang = $language->id;
                $extrasGroupLanguage->save();
            }

            return response()->json([
                'success' => 1,
                'msg' => "Successfully saved",
                "data" => $extrasGroup
            ]);
        }

        return response()->json([
            'success' => 0,
            'msg' => "Error in saving language"
        ]);
    }

    public function datatable(Request $request)
    {
        $product_id = $request->input('product_id');
        $totalData = ProductExtrasGroup::where([
            "id_product" => $product_id
        ])->count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');

        $defaultLanguage = Languages::where("default", 1)->first();

        if (empty($request->input('search'))) {
            $datas = ProductExtrasGroup::select("product_extra_groups.*", "product_extra_groups_language.name", "product_extra_input_types.name as type_name")
                ->join('product_extra_groups_language', 'product_extra_groups_language.id_extra_group', '=', 'product_extra_groups.id')
                ->join('product_extra_input_types', 'product_extra_input_types.id', '=', 'product_extra_groups.type')
                ->where([
                    'product_extra_groups_language.id_lang' => $defaultLanguage->id,
                    "product_extra_groups.id_product" => $product_id
                ])
                ->offset($start)
                ->limit($limit)
                ->get();
        } else {
            $search = $request->input('search');

            $datas = ProductExtrasGroup::select("product_extra_groups.*", "product_extra_groups_language.name", "product_extra_input_types.name as type_name")
                ->join('product_extra_groups_language', 'product_extra_groups_language.id_extra_group', '=', 'product_extra_groups.id')
                ->join('product_extra_input_types', 'product_extra_input_types.id', '=', 'product_extra_groups.type')
                ->where([
                    'product_extra_groups_language.id_lang' => $defaultLanguage->id,
                    "product_extra_groups.id_product" => $product_id
                ])
                ->where('name', 'LIKE', "%{$search}%")
                ->where('id', 'LIKE', "%{$search}%")
                ->offset($start)
                ->limit($limit)
                ->get();

            $totalFiltered = ProductExtrasGroup::select("product_extra_groups.*", "product_extra_groups_language.name", "product_extra_input_types.name as type_name")
                ->join('product_extra_groups_language', 'product_extra_groups_language.id_extra_group', '=', 'product_extra_groups.id')
                ->join('product_extra_input_types', 'product_extra_input_types.id', '=', 'product_extra_groups.type')
                ->where([
                    'product_extra_groups_language.id_lang' => $defaultLanguage->id,
                    "product_extra_groups.id_product" => $product_id
                ])
                ->where('id', 'LIKE', "%{$search}%")
                ->where('name', 'LIKE', "%{$search}%")
                ->count();
        }

        $responseData = array();
        if (!empty($datas)) {
            foreach ($datas as $data) {

                $nestedData['id'] = $data->id;
                $nestedData['name'] = $data->name;
                $nestedData['type'] = $data->type_name;
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

        $extrasGroup = ProductExtrasGroup::findOrFail($id);
        if ($extrasGroup) {
            $extrasGroup->delete();
        }

        return response()->json([
            'success' => 1,
            'msg' => "Successfully deleted"
        ]);
    }

    public function get(Request $request)
    {
        $id = $request->id;
        $extras_group = ProductExtrasGroup::findOrFail($id);
        $extras_group_language = ProductExtrasGroupLanguage::select("product_extra_groups_language.*", "language.short_name")->where("id_extra_group", $id)
            ->join('language', 'language.id', '=', 'product_extra_groups_language.id_lang')
            ->get();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => [
                "extras_group" => $extras_group,
                "extras_group_language" => $extras_group_language
            ]
        ]);
    }

    public function active(Request $request)
    {
        $product_id = $request->product_id;

        $defaultLanguage = Languages::where("default", 1)->first();

        $data = ProductExtrasGroup::select("product_extra_groups.*", "product_extra_groups_language.name")
            ->join('product_extra_groups_language', 'product_extra_groups_language.id_extra_group', '=', 'product_extra_groups.id')
            ->where([
                'product_extra_groups_language.id_lang' => $defaultLanguage->id,
                "product_extra_groups.id_product" => $product_id
            ])->get();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => $data
        ]);
    }
}
