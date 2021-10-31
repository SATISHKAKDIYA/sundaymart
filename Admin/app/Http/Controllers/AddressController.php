<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Addresses;
use Illuminate\Http\Request;

class AddressController extends Controller
{
    public function save(Request $request)
    {
        $addressText = $request->address;
        $latitude = $request->latitude;
        $longitude = $request->longitude;
        $client_id = $request->client_id;
        $id = $request->id;

        if ($id > 0)
            $address = Addresses::findOrFail($id);
        else
            $address = new Addresses();

        $address->address = $addressText;
        $address->latitude = $latitude;
        $address->longtitude = $longitude;
        $address->default = 1;
        $address->id_user = $client_id;
        $address->active = 1;
        if ($id > 0)
            $address->updated_at = date("Y-m-d H:i:s");
        else
            $address->created_at = date("Y-m-d H:i:s");

        if ($address->save()) {
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
        $totalData = Addresses::count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');

        if (empty($request->input('search'))) {
            $datas = Addresses::select("addresses.*", "clients.name", "clients.surname", "clients.id as client_id")->join('clients', 'clients.id', '=', 'addresses.id_user')
                ->offset($start)
                ->limit($limit)
                ->get();
        } else {
            $search = $request->input('search');

            $datas = Addresses::select("addresses.*", "clients.name", "clients.surname", "clients.id as client_id")->join('clients', 'clients.id', '=', 'addresses.id_user')
                ->where('address', 'LIKE', "%{$search}%")
                ->where('id', 'LIKE', "%{$search}%")
                ->offset($start)
                ->limit($limit)
                ->get();

            $totalFiltered = Addresses::select("addresses.*", "clients.name", "clients.surname", "clients.id as client_id")->join('clients', 'clients.id', '=', 'addresses.id_user')
                ->where('id', 'LIKE', "%{$search}%")
                ->where('address', 'LIKE', "%{$search}%")
                ->count();
        }

        $responseData = array();
        if (!empty($datas)) {
            foreach ($datas as $data) {
                $nestedData['id'] = $data->id;
                $nestedData['address'] = $data->address;
                $nestedData['client'] = $data->name . " " . $data->surname . " (ID: " . $data->client_id . ")";
                $nestedData['latitude'] = $data->latitude;
                $nestedData['longtitude'] = $data->longtitude;
                $nestedData['default'] = $data->default;
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

        $shop = Addresses::findOrFail($id);
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
        $client_id = $request->client_id;

        $addresses = Addresses::where([
            "active" => 1,
            "id_user" => $client_id
        ])->get();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => $addresses
        ]);
    }
}
