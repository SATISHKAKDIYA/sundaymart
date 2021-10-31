<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Languages;
use Illuminate\Http\Request;

class LanguageController extends Controller
{
    public function save(Request $request)
    {
        $name = $request->name;
        $short_code = $request->short_code;
        $image_path = $request->image_path;
        $active = $request->active;
        $id = $request->id;

        if ($id > 0)
            $languageModel = Languages::findOrFail($id);
        else
            $languageModel = new Languages();
        $languageModel->name = $name;
        $languageModel->short_name = $short_code;
        $languageModel->image_url = $image_path;
        $languageModel->active = $active;

        $defaultLanguages = Languages::where("default", 1)->first();
        if (!$defaultLanguages)
            $languageModel->default = 1;

        if ($languageModel->save()) {
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

            $datas = Languages::where('id', 'LIKE', "%{$search}%")
                ->where('name', 'LIKE', "%{$search}%")
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
                $nestedData['id'] = $data->id;
                $nestedData['name'] = $data->name;
                $nestedData['short_code'] = $data->short_name;
                $nestedData['image_url'] = $data->image_url;
                $nestedData['active'] = $data->active;
                $nestedData['default'] = $data->default;
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

        $language = Languages::findOrFail($id);
        if ($language && $language->default != 1) {
            $language->delete();
        }

        return response()->json([
            'success' => 1,
            'msg' => "Successfully deleted"
        ]);
    }

    public function get(Request $request)
    {
        $id = $request->id;

        $language = Languages::findOrFail($id);

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => $language
        ]);
    }

    public function makeDefault(Request $request)
    {
        $id = $request->id;
        $defaultLanguages = Languages::where("default", 1)->first();
        if ($defaultLanguages) {
            $defaultLanguages->default = 0;
            $defaultLanguages->save();
        }

        $language = Languages::findOrFail($id);
        if ($language) {
            $language->default = 1;
            $language->save();
        }

        return response()->json([
            'success' => 1,
            'msg' => "Successfully changed"
        ]);
    }

    public function active()
    {
        $languages = Languages::where("active", 1)->get();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => $languages
        ]);
    }
}
