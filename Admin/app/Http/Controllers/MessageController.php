<?php

namespace App\Http\Controllers;

use App\Events\PrivateChat;
use App\Models\Dialog;
use App\Models\Message;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class MessageController extends Controller
{
    public function dialog(Request $request){

        $dialog = Dialog::with('messages')->where(function ($query) use ($request) {
            $query->where('first_id', '=', $request->auth_id)
                ->where('second_id', '=', $request->other_id);
        })->orwhere(function ($query) use ($request) {
            $query->where('second_id', '=', $request->auth_id)
                ->where('first_id', '=', $request->other_id);
        })->first();

        if(!$dialog){
            $dialog = Dialog::create([
                'first_id' => $request->auth_id,
                'second_id' => $request->other_id
            ]);
        }
        foreach ($dialog->messages as $message){
            if($message->user_id == $request->other_id){
                $message->update(['is_read' => 1]);
            }
        }

        return response()->json($dialog);
    }

    public function sendMessage(Request $request){

        PrivateChat::dispatch($request->all());

        return response()->json([
            'success' => 0,
            'msg' => "Message send",
            'data' => ['asdasd']
        ]);

        $validator = Validator::make($request->all(), [
            'text' => 'required|min:1|max:500'
        ]);


        if ($validator->fails()) {
            return response()->json($validator->errors());
        }

        $message = Message::create([
            'user_id' => $request->user_id,
            'text' => $request->text,
            'dialog_id' => $request->dialog_id
        ]);

        if (isset($message)){
            $dialog = Dialog::where('id', $message->dialog_id)->first();
            $dialog->update(['updated_at' => Carbon::now()]);

            PrivateChat::dispatch($message);

            return response()->json([
                'success' => 0,
                'msg' => "Message send",
                'data' => $message
            ]);
        }
    }
}
