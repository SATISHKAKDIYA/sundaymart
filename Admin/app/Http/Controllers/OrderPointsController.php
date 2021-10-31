<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\OrderPoints;
use App\Models\Languages;

use Illuminate\Support\Facades\Validator;


class OrderPointsController extends Controller
{
    public function save(Request $request){
       
        $v = Validator::make($request->all(), [
            'point' => 'required|numeric',
            'id_shop' => 'required|numeric'
        ]);

        if ($v->fails()) {
            return response()->json([
                'error' => 1,
                'msg' => $v->errors()
            ]);
        }

        $id = $request->id;
        $point = $request->point;
        $id_shop = $request->id_shop;
                
        if ($id > 0){
            $point = OrderPoints::findOrFail($id);
        }else{
            $point = new OrderPoints();
        }

        $point->point = $point;
        $point->id_shop = $id_shop;

        if ($id > 0)
            $point->updated_at = date("Y-m-d H:i:s");
        else
            $point->created_at = date("Y-m-d H:i:s");

        if ($point->save()) {

            return response()->json([
                'success' => 1,
                'msg' => "Successfully saved"
            ]);
        }

        return response()->json([
            'success' => 0,
            'msg' => "Error in saving."
        ]);

    }

    public function datatable(Request $request)
    {
        $totalData = OrderPoints::count();

        $totalFiltered = 0;

        $limit = $request->input('length');
        $start = $request->input('start');

        $sort_field = 'order_points.id';
        $sort_type = 'asc';
            
        if (!empty($request->input('sort_field')))
        $sort_field = $request->input('sort_field');

        if (!empty($request->input('sort_type')))
        $sort_type = $request->input('sort_type');

        if (!empty($request->input('search')))
        $search = $request->input('search');

        $defaultLanguage = Languages::where("default", 1)->first();

        $datas = OrderPoints::select("order_points.*", "shops_language.*")
                ->join('shops_language', 'shops_language.id_shop', '=', 'order_points.id_shop')
                ->where('shops_language.id_lang', $defaultLanguage);

                if(isset($search)){
                    $datas = $datas->where("shops_language.name", "LIKE", "%{$search}%")
                    ->where("shops_language.description", "LIKE", "%{$search}%")
                    ->where("shops_language.info", "LIKE", "%{$search}%")
                    ->where("shops_language.address", "LIKE", "%{$search}%");
                }
                $datas = $datas->orderBy($sort_field, $sort_type)
                ->offset($start)
                ->limit($limit)
                ->get();

                if(isset($search)){
                    $totalFiltered = OrderPoints::select("order_points.*", "shops_language.*")
                    ->join('shops_language', 'shops_language.id_shop', '=', 'order_points.id_shop')
                    ->where('shops_language.id_lang', $defaultLanguage);
    
                    if(isset($search)){
                        $totalFiltered = $totalFiltered->where("shops_language.name", "LIKE", "%{$search}%")
                        ->where("shops_language.description", "LIKE", "%{$search}%")
                        ->where("shops_language.info", "LIKE", "%{$search}%")
                        ->where("shops_language.address", "LIKE", "%{$search}%");
                    }
                    $totalFiltered = $totalFiltered->orderBy($sort_field, $sort_type)
                    ->offset($start)
                    ->limit($limit)
                    ->count();
                }



            if(!empty($datas)){
                return response()->json([
                    'success' => 1,
                    'msg' => "Success",
                    'data' => [
                        "total" => intval($totalData),
                        "filtered" => intval($totalFiltered),
                        "order_points" => $datas
                    ]
                ]);

            } 

            return response()->json([
                'success' => 0,
                'msg' => "data not available."
            ]);
            
    }
    
    public function delete(Request $request){
        $id = $request->id;

        $point = OrderPoints::findOrFail($id);
        if ($point) {
            $point->delete();
        }

        return response()->json([
            'success' => 1,
            'msg' => "Successfully deleted"
        ]);
    }

    public function get(Request $request){
        $v = Validator::make($request->all(), [
            'id' => 'required'
        ]);

        if ($v->fails()) {
            return response()->json([
                'error' => 1,
                'msg' => $v->errors()
            ]);
        }

        $id = $request->id;
        $defaultLanguage = Languages::where("default", 1)->first();

        if ($id > 0){

            $point = OrderPoints::select("order_points.*", "shops_language.*")
                    ->join('shops_language', 'shops_language.id_shop', '=', 'order_points.id_shop')
                    ->where('shops_language.id_lang', $defaultLanguage)
                    ->where('order_points.id', $id)->first();
        }

        if(!empty($point)){
            return response()->json([
                'success' => 1,
                'msg' => "Success",
                'data' => $point
            ]);
        }
           
        return response()->json([
            'success' => 0,
            'msg' => "No data available."
        ]);
    }
}
