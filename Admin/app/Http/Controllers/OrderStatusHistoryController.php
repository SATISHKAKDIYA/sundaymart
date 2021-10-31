<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\OrderStatusHistory;
use Illuminate\Support\Facades\Validator;

class OrderStatusHistoryController extends Controller
{
    public function save(Request $request){
       
        $v = Validator::make($request->all(), [
            'id_order' => 'required|numeric',
            'status' => 'required|numeric',
        ]);

        if ($v->fails()) {
            return response()->json([
                'error' => 1,
                'msg' => $v->errors()
            ]);
        }

        $id = $request->id;
        $id_order = $request->id_order;
        $status = $request->status;
                
        if ($id > 0){
            $history = OrderStatusHistory::findOrFail($id);
        }else{
            $history = new OrderStatusHistory();
        }
        $history->id_order = $id_order;
        $history->status = $status;
        $history->date = date("Y-m-d H:i:s");
        if ($history->save()) {

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

}
