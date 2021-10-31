<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Clients;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;


class ClientController extends Controller
{
    use ApiResponse;

    public function save(Request $request) {
        $name = $request->name;
        $surname = $request->surname;
        $email = $request->email;
        $phone = $request->phone;
        $password = $request->password;
        $image_path = $request->image_path;
        $active = $request->active;
        $id = $request->id;

        if ($id > 0)
            $client = Clients::findOrFail($id);
        else
            $client = new Clients();

        $client->name = $name;
        $client->surname = $surname;
        $client->image_url = $image_path;
        $client->email = $email;
        $client->phone = $phone;
        $client->active = $active;
        $client->auth_type = 1;
        $client->token = "1";
        $client->device_type = 1;
        $client->password = Hash::make($password);
        if ($id == null)
        if ($id > 0)
            $client->updated_at = date("Y-m-d H:i:s");
        else
            $client->created_at = date("Y-m-d H:i:s");

        if ($client->save()) {
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
        $totalData = Clients::count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');

        if (empty($request->input('search'))) {
            $datas = Clients::offset($start)
                ->limit($limit)
                ->get();
        } else {
            $search = $request->input('search');

            $datas = Clients::where('name', 'LIKE', "%{$search}%")
                ->where('id', 'LIKE', "%{$search}%")
                ->offset($start)
                ->limit($limit)
                ->get();

            $totalFiltered = Clients::where('id', 'LIKE', "%{$search}%")
                ->where('name', 'LIKE', "%{$search}%")
                ->count();
        }

        $responseData = array();
        if (!empty($datas)) {
            foreach ($datas as $data) {
                $nestedData['id'] = $data->id;
                $nestedData['name'] = $data->name;
                $nestedData['surname'] = $data->surname;
                $nestedData['image_url'] = $data->image_url;
                $nestedData['phone'] = $data->phone;
                $nestedData['email'] = $data->email;
                $nestedData['auth_type'] = $data->auth_type;
                $nestedData['device_type'] = $data->device_type;
                $nestedData['active'] = $data->active;
                $nestedData['options'] = [
                    'delete' => 1,
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

        $shop = Clients::findOrFail($id);
        if ($shop) {
            $shop->delete();
        }

        return response()->json([
            'success' => 1,
            'msg' => "Successfully deleted"
        ]);
    }

    public function active(Request $request)
    {
        $client = Clients::where("active", 1)->get();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => $client
        ]);
    }

    public function getTotalClientsCount() {
        $count = Clients::count();

        return $this->successResponse("success", $count);
    }
}
