<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Dialogs;
use App\Models\Messages;
use Illuminate\Support\Facades\Validator;


class DialogsController extends Controller
{
    public function save(Request $request){
       
        $v = Validator::make($request->all(), [
            'from' => 'required',
            'to' => 'required',
            'user_id' => 'required',
            'user_type' => 'required',
            'text' => 'required'
        ]);

        if ($v->fails()) {
            return response()->json([
                'error' => 1,
                'msg' => $v->errors()
            ]);
        }

        $id = $request->id;
        $from = $request->from;
        $to = $request->to;
        $user_id = $request->user_id;
        $user_type = $request->user_type;
        $text = $request->text;
                
        if ($id > 0){
            $dialog = Dialogs::findOrFail($id);
        }else{
            $dialog = new Dialogs();
        }

        $dialog->from = $from;
        $dialog->to = $to;

        if ($id > 0)
            $dialog->updated_at = date("Y-m-d H:i:s");
        else
            $dialog->created_at = date("Y-m-d H:i:s");

        if ($dialog->save()) {

            if ($id > 0){
                $messages = Messages::where('dialog_id', $id)->first();
                $messages->updated_at = date("Y-m-d H:i:s");
            }else{
                $messages = new Messages();
                $messages->created_at = date("Y-m-d H:i:s");
            }

            $messages->user_id = $user_id;
            $messages->user_type = $user_type;
            $messages->dialog_id = $dialog->id;
            $messages->user_type = $text;
            
            $messages->save();

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
        $totalData = Dialogs::count();

        $totalFiltered = 0;

        $limit = $request->input('length');
        $start = $request->input('start');

        $sort_field = 'dialogs.id';
        $sort_type = 'asc';
            
        if (!empty($request->input('sort_field')))
        $sort_field = $request->input('sort_field');

        if (!empty($request->input('sort_type')))
        $sort_type = $request->input('sort_type');

        if (!empty($request->input('search')))
        $search = $request->input('search');

        $id_lang = $request->id_lang;

        $datas = Dialogs::select("dialogs.*", "messages.*")
                ->join('messages', 'messages.dialog_id', '=', 'dialogs.id');

                if(isset($search)){
                    $datas = $datas->where("messages.text", "LIKE", "%{$search}%");
                }
                $datas = $datas->orderBy($sort_field, $sort_type)
                ->offset($start)
                ->limit($limit)
                ->get();

                if(isset($search)){
                    $totalFiltered = Dialogs::select("dialogs.*", "messages.*")
                    ->join('messages', 'messages.dialog_id', '=', 'dialogs.id');
    
                    if(isset($search)){
                        $datas = $datas->where("messages.text", "LIKE", "%{$search}%");
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
                        "dialogs" => $datas
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

        $dialog = Dialogs::findOrFail($id);
        if ($dialog) {
            $dialog->delete();
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

            $dialog = Dialogs::select("dialogs.*", "messages.*")
                ->join('messages', 'messages.dialog_id', '=', 'dialogs.id')
                ->where('dialogs.id', $id)->first();

        }

        if(!empty($dialog)){
            return response()->json([
                'success' => 1,
                'msg' => "Success",
                'data' => $dialog
            ]);
        }
           
        return response()->json([
            'success' => 0,
            'msg' => "No data available."
        ]);
    }
}
