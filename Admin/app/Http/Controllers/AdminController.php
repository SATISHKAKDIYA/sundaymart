<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Admin;
use App\Models\Languages;
use App\Models\ShopsLanguage;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AdminController extends Controller
{
    public function activate(Request $request)
    {
        $id = $request->id;
        $active = $request->activate;

        $admin = Admin::findOrFail($id);

        if ($admin) {
            $admin->active = $active;
            if ($admin->save()) {
                return response()->json([
                    'success' => 1,
                    'msg' => "Successfully changed"
                ]);
            }
        }

        return response()->json([
            'success' => 0,
            'msg' => "Error in activating"
        ]);

    }


    public function create(Request $request)
    {
        $name = $request->name;
        $surname = $request->surname;
        $email = $request->email;
        $phone = $request->phone;
        $image_path = $request->image_path;
        $password = $request->password;

        if ($request->has('email') && !empty($request->input('email'))) {
            if (Admin::where('email', '=', $request->email)->exists()) {

                return response()->json([
                    'success' => 0,
                    'msg' => "Manager email already exist in our system."
                ]);

            }
        }

        $admin = new Admin();

        $admin->name = $name;
        $admin->surname = $surname;
        $admin->image_url = $image_path;
        $admin->email = $email;
        $admin->phone = $phone;
        $admin->id_role = 2;
        $admin->id_shop = 0;
        $admin->is_requested = 1;
        $admin->active = 0;
        $admin->password = Hash::make($password);
        $admin->offline = 0;
        $admin->created_at = date("Y-m-d H:i:s");

        if ($admin->save()) {
            return response()->json([
                'success' => 1,
                'msg' => "Manager Successfully saved"
            ]);
        }

        return response()->json([
            'success' => 0,
            'msg' => "Error in saving language"
        ]);
    }


    public function save(Request $request)
    {
        $name = $request->name;
        $surname = $request->surname;
        $email = $request->email;
        $phone = $request->phone;
        $shop_id = $request->shop_id;
        $role_id = $request->role_id;
        $image_path = $request->image_path;
        $active = $request->active;
        $id = $request->id;
        $password = $request->password;

        if ($id > 0)
            $admin = Admin::findOrFail($id);
        else
            $admin = new Admin();

        $admin->name = $name;
        $admin->surname = $surname;
        $admin->image_url = $image_path;
        $admin->email = $email;
        $admin->phone = $phone;
        $admin->id_role = $role_id;
        $admin->id_shop = $shop_id;
        $admin->active = $active;
        $admin->password = Hash::make($password);
        if ($id == null)
            $admin->offline = 0;
        if ($id > 0)
            $admin->updated_at = date("Y-m-d H:i:s");
        else
            $admin->created_at = date("Y-m-d H:i:s");

        if ($admin->save()) {
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
        $totalData = Admin::count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');

        $defaultLanguage = Languages::where("default", 1)->first();

        if (empty($request->input('search'))) {
            $datas = Admin::select("admins.*", "roles.name as role_name")
                ->join('roles', 'roles.id', '=', 'admins.id_role')
                ->offset($start)
                ->limit($limit)
                ->get();
        } else {
            $search = $request->input('search');

            $datas = Admin::select("admins.*", "roles.name as  role_name")
                ->join('roles', 'roles.id', '=', 'admins.id_role')
                ->where('name', 'LIKE', "%{$search}%")
                ->where('id', 'LIKE', "%{$search}%")
                ->offset($start)
                ->limit($limit)
                ->get();

            $totalFiltered = Admin::select("admins.*", "roles.name as  role_name")
                ->join('roles', 'roles.id', '=', 'admins.id_role')
                ->where('id', 'LIKE', "%{$search}%")
                ->where('name', 'LIKE', "%{$search}%")
                ->count();
        }

        $responseData = array();
        if (!empty($datas)) {
            foreach ($datas as $data) {
                $shop = null;
                if ($data['id_shop'] != null)
                    $shop = ShopsLanguage::where([
                        'id_lang' => $defaultLanguage->id,
                        'id_shop' => $data['id_shop']
                    ])->first();

                $nestedData['id'] = $data->id;
                $nestedData['name'] = $data->name;
                $nestedData['surname'] = $data->surname;
                $nestedData['shop'] = $data['id_shop'] != null && $shop ? $shop->name : "-";
                $nestedData['role'] = $data->role_name;
                $nestedData['id_role'] = $data->id_role;
                $nestedData['image_url'] = $data->image_url;
                $nestedData['is_requested'] = $data->is_requested;
                $nestedData['phone'] = $data->phone;
                $nestedData['email'] = $data->email;
                $nestedData['id_role'] = $data->id_role;
                $nestedData['id_shop'] = $data->id_shop;
                $nestedData['offline'] = $data->offline;
                $nestedData['active'] = $data->active;
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

        $admin = Admin::findOrFail($id);
        if ($admin) {
            $admin->delete();
        }

        return response()->json([
            'success' => 1,
            'msg' => "Successfully deleted"
        ]);
    }

    public function get(Request $request)
    {
        $id = $request->id;

        $admin = Admin::findOrFail($id);

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => $admin
        ]);
    }

    public function deliveryBoyActive(Request $request)
    {
        $shop_id = $request->shop_id;

        $delivery_boys = Admin::where([
            "id_shop" => $shop_id,
            "id_role" => 3
        ])->get();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => $delivery_boys
        ]);
    }
}
