<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Languages;
use App\Models\ProductExtras;
use App\Models\ProductExtrasLanguage;
use Illuminate\Http\Request;

class ExtraController extends Controller
{
    public function datatable(Request $request)
    {
        $product_id = $request->input('product_id');
        $totalData = ProductExtras::join('product_extra_groups', 'product_extra_groups.id', '=', 'product_extras.id_extra_group')
            ->where([
                "product_extra_groups.id_product" => $product_id
            ])
            ->count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');


        $defaultLanguage = Languages::where("default", 1)->first();

        if (empty($request->input('search'))) {
            $datas = ProductExtras::select("product_extras.*", "product_extras_language.name", "product_extras_language.description", "product_extra_groups_language.name as group_name")
                ->join('product_extras_language', 'product_extras_language.id_extras', '=', 'product_extras.id')
                ->join('product_extra_groups', 'product_extra_groups.id', '=', 'product_extras.id_extra_group')
                ->join('product_extra_groups_language', 'product_extra_groups_language.id_extra_group', '=', 'product_extras.id_extra_group')
                ->where([
                    'product_extras_language.id_lang' => $defaultLanguage->id,
                    'product_extra_groups_language.id_lang' => $defaultLanguage->id,
                    "product_extra_groups.id_product" => $product_id
                ])
                ->offset($start)
                ->limit($limit)
                ->get();
        } else {
            $search = $request->input('search');

            $datas = ProductExtras::select("product_extras.*", "product_extras_language.name", "product_extras_language.description", "product_extra_groups_language.name as group_name")
                ->join('product_extras_language', 'product_extras_language.id_extras', '=', 'product_extras.id')
                ->join('product_extra_groups', 'product_extra_groups.id', '=', 'product_extras.id_extra_group')
                ->join('product_extra_groups_language', 'product_extra_groups_language.id_extra_group', '=', 'product_extras.id_extra_group')
                ->where([
                    'product_extras_language.id_lang' => $defaultLanguage->id,
                    'product_extra_groups_language.id_lang' => $defaultLanguage->id,
                    "product_extra_groups.id_product" => $product_id
                ])
                ->where('name', 'LIKE', "%{$search}%")
                ->where('id', 'LIKE', "%{$search}%")
                ->offset($start)
                ->limit($limit)
                ->get();

            $totalFiltered = ProductExtras::select("product_extras.*", "product_extras_language.name", "product_extras_language.description", "product_extra_groups_language.name as group_name")
                ->join('product_extras_language', 'product_extras_language.id_extras', '=', 'product_extras.id')
                ->join('product_extra_groups', 'product_extra_groups.id', '=', 'product_extras.id_extra_group')
                ->join('product_extra_groups_language', 'product_extra_groups_language.id_extra_group', '=', 'product_extras.id_extra_group')
                ->where([
                    'product_extras_language.id_lang' => $defaultLanguage->id,
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
                $nestedData['description'] = $data->description;
                $nestedData['group'] = $data->group_name;
                $nestedData['price'] = $data->price;
                $nestedData['image_url'] = $data->image_url;
                $nestedData['background_color'] = $data->background_color;
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

    public function save(Request $request)
    {
        $name = $request->name;
        $description = $request->description;
        $image_url = $request->image_url;
        $active = $request->active;
        $extra_group_id = $request->extra_group_id;
        $price = $request->price;
        $id = $request->id;
        $background_color = $request->background_color;
        $quantity = $request->quantity;

        if ($id > 0)
            $extras = ProductExtras::findOrFail($id);
        else
            $extras = new ProductExtras();

        $extras->background_color = $background_color;
        $extras->price = $price;
        $extras->quantity = $quantity;
        $extras->image_url = $image_url;
        $extras->active = $active;
        $extras->id_extra_group = $extra_group_id;
        if ($extras->save()) {
            $extras_id = $extras->id;
            foreach ($name as $key => $value) {
                $language = Languages::where("short_name", $key)->first();

                if ($id > 0) {
                    $extrasLanguage = ProductExtrasLanguage::where([
                        "id_extras" => $id,
                        "id_lang" => $language->id
                    ])->first();
                    if (!$extrasLanguage)
                        $extrasLanguage = new ProductExtrasLanguage();
                } else
                    $extrasLanguage = new ProductExtrasLanguage();

                $extrasLanguage->name = $value;
                $extrasLanguage->description = $description[$key];
                $extrasLanguage->id_extras = $extras_id;
                $extrasLanguage->id_lang = $language->id;
                $extrasLanguage->save();
            }

            return response()->json([
                'success' => 1,
                'msg' => "Successfully saved",
                "data" => $extras
            ]);
        }

        return response()->json([
            'success' => 0,
            'msg' => "Error in saving language"
        ]);
    }

    public function delete(Request $request)
    {
        $id = $request->id;

        $extrasGroup = ProductExtras::findOrFail($id);
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
        $extras = ProductExtras::join('product_extra_groups', 'product_extra_groups.id', '=', 'product_extras.id_extra_group')
            ->where("product_extras.id", $id)
            ->first();
        $extras_group = ProductExtrasLanguage::select("product_extras_language.*", "language.short_name")
            ->where("id_extras", $id)
            ->join('language', 'language.id', '=', 'product_extras_language.id_lang')
            ->get();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => [
                "extras" => $extras,
                "extras_language" => $extras_group
            ]
        ]);
    }
}
