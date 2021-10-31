<?php

namespace App\Http\Controllers;

use App\Models\Admin;
use App\Models\Clients;
use Illuminate\Http\Request;
use App\Models\Notifications;


class NotificationsController extends Controller
{
    private $push_token = "AAAA5_EU5F8:APA91bHHXoSXt4cToBeCDNKPnKlxdqRA9dhLC33KQ8rQtXVYt51JFmS9_7wATcNX08cvG3DEbxn8DtAaT09iQFYizKLzktyVkmbpGBs9TRfFJ2k77RVfNfTyjU93Iuzbxa15mXzz5nYv";

    public function save(Request $request)
    {
        $id = $request->id;
        $title = $request->title;
        $description = $request->description;
        $has_image = $request->has_image;
        $image_url = $request->image_url;
        $active = $request->active;
        $send_time = $request->send_time;
        $id_shop = $request->id_shop;

        if ($id > 0)
            $notification = Notifications::findOrFail($id);
        else
            $notification = new Notifications();

        $notification->title = $title;
        $notification->description = $description;
        $notification->has_image = $has_image;
        $notification->image_url = $image_url;
        $notification->active = $active;
        $notification->id_shop = $id_shop;
        $notification->id_user = Admin::getUserId();
        $notification->is_sent = 0;
        $notification->send_time = $send_time;

        if ($id > 0)
            $notification->updated_at = date("Y-m-d H:i:s");
        else
            $notification->created_at = date("Y-m-d H:i:s");
        if ($notification->save()) {

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
        $totalData = Notifications::count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');

        if (empty($request->input('search'))) {
            $datas = Notifications::where('active', 1)
                ->offset($start)
                ->limit($limit)
                ->get();
        } else {
            $search = $request->input('search');

            $datas = Notifications::where('active', 1)
                ->where('title', 'LIKE', "%{$search}%")
                ->where('description', 'LIKE', "%{$search}%")
                ->where('id', 'LIKE', "%{$search}%")
                ->offset($start)
                ->limit($limit)
                ->get();

            $totalFiltered = Notifications::where('active', 1)
                ->where('title', 'LIKE', "%{$search}%")
                ->where('description', 'LIKE', "%{$search}%")
                ->where('id', 'LIKE', "%{$search}%")
                ->offset($start)
                ->limit($limit)
                ->count();
        }

        $responseData = array();
        if (!empty($datas)) {
            foreach ($datas as $data) {
                $nestedData['id'] = $data->id;
                $nestedData['title'] = $data->title;
                $nestedData['description'] = $data->description;
                $nestedData['has_image'] = $data->has_image;
                $nestedData['image_url'] = $data->image_url;
                $nestedData['active'] = $data->active;
                $nestedData['is_sent'] = $data->is_sent;
                $nestedData['send_time'] = $data->send_time;
                $nestedData['options'] = [
                    'delete' => 1,
                    'edit' => 1
                ];

                if($data->is_sent == 0)
                    $nestedData['options']['send'] = 1;

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
        $notification = Notifications::find($id);

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => $notification
        ]);
    }

    public function delete(Request $request)
    {
        $id = $request->id;

        $notification = Notifications::findOrFail($id);
        if ($notification) {
            $notification->delete();
        }

        return response()->json([
            'success' => 1,
            'msg' => "Successfully deleted"
        ]);
    }

    public function sendNotification(Request $request) {
        $id = $request->id;

        $notification = Notifications::findOrFail($id);
        if ($notification) {
            $clients = Clients::select("push_token")->where([
                "active" => 1,
            ])->whereNotNull("push_token")->get();

            $clientsIds = [];
            foreach ($clients as $client) {
                $clientsIds[] = $client->push_token;
            }

            if(count($clients) > 0) {
                $url = 'https://fcm.googleapis.com/fcm/send';

                $fields = array(
                    'registration_ids' => $clientsIds,
                    "notification" => [
                        "body" => $notification->title,
                        "title" => "Githubit.com",
                        //"icon" => "ic_launcher"
                    ],
                );
                $fields = json_encode($fields);

                $headers = array(
                    'Authorization: key=' . $this->push_token,
                    'Content-Type: application/json'
                );

                $ch = curl_init();
                curl_setopt($ch, CURLOPT_URL, $url);
                curl_setopt($ch, CURLOPT_POST, true);
                curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
                curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
                curl_setopt($ch, CURLOPT_POSTFIELDS, $fields);

                $result = curl_exec($ch);
                curl_close($ch);

                $notification->is_sent = 1;
                $notification->save();
            }
        }

        return response()->json([
            'success' => 1,
            'msg' => "Successfully deleted",
            "result" => $result
        ]);
    }

}
