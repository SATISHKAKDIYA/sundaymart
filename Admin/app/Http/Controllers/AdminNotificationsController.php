<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\AdminNotifications;
use Illuminate\Support\Facades\Validator;

class AdminNotificationsController extends Controller
{
    public function datatable(Request $request)
    {
        $notifications = AdminNotifications::get();

            if(!empty($notifications)){
                return response()->json([
                    'success' => 1,
                    'msg' => "Success",
                    'data' => $notifications
                ]);
            } 

            return response()->json([
                'success' => 0,
                'msg' => "data not available."
            ]);
            
    }
    
    public function delete(Request $request){
        $id = $request->id;

        $notification = AdminNotifications::findOrFail($id);
        if ($notification) {
            $notification->delete();
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

            $notification = AdminNotifications::findOrFail($id);

        }

        if(!empty($notification)){
            return response()->json([
                'success' => 1,
                'msg' => "Success",
                'data' => $notification
            ]);
        }
           
        return response()->json([
            'success' => 0,
            'msg' => "No data available."
        ]);
    }
}
