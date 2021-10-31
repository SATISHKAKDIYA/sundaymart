<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\OrderPointsHistory;
use App\Models\Languages;
use Illuminate\Support\Facades\Validator;

class OrderPointsHistoryController extends Controller
{
    public function datatable(Request $request)
    {
        $totalData = OrderPointsHistory::count();

        $totalFiltered = 0;

        $limit = $request->input('length');
        $start = $request->input('start');

        $sort_field = 'order_points_history.id';
        $sort_type = 'asc';
            
        if (!empty($request->input('sort_field')))
        $sort_field = $request->input('sort_field');

        if (!empty($request->input('sort_type')))
        $sort_type = $request->input('sort_type');

        if (!empty($request->input('search')))
        $search = $request->input('search');

        $datas = OrderPointsHistory::select("order_points_history.*", "clients.*")
                ->join('clients', 'clients.id', '=', 'order_points_history.id_client');

                if(isset($search)){
                    $datas = $datas->where("order_points_history.point", "LIKE", "%{$search}%")
                    ->where("clients.name", "LIKE", "%{$search}%")
                    ->where("clients.surname", "LIKE", "%{$search}%")
                    ->where("clients.phone", "LIKE", "%{$search}%")
                    ->where("clients.email", "LIKE", "%{$search}%");
                }
                $datas = $datas->orderBy($sort_field, $sort_type)
                ->offset($start)
                ->limit($limit)
                ->get();

                if(isset($search)){
                    $totalFiltered = OrderPointsHistory::select("order_points_history.*", "clients.*")
                    ->join('clients', 'clients.id', '=', 'order_points_history.id_client');
    
                    if(isset($search)){
                        $datas = $datas->where("order_points_history.point", "LIKE", "%{$search}%")
                        ->where("clients.name", "LIKE", "%{$search}%")
                        ->where("clients.surname", "LIKE", "%{$search}%")
                        ->where("clients.phone", "LIKE", "%{$search}%")
                        ->where("clients.email", "LIKE", "%{$search}%");
                    }
                    $datas = $datas->orderBy($sort_field, $sort_type)
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
                        "history" => $datas
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

        $point = OrderPointsHistory::findOrFail($id);
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

        if ($id > 0){

            $point = OrderPointsHistory::select("order_points_history.*", "clients.*")
                        ->join('clients', 'clients.id', '=', 'order_points_history.id_client')
                        ->where('order_points_history.id', $id)->first();
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
