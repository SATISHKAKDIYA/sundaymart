<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Permissions;
use App\Models\RolePermissions;
use App\Models\Roles;
use Illuminate\Http\Request;

class RolePermissionController extends Controller
{
    public function roles(Request $request)
    {
        $roles = Roles::where("active", 1)->get();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => $roles
        ]);
    }

    public function datatable(Request $request)
    {
        $totalData = Roles::count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');

        if (empty($request->input('search'))) {
            $datas = Roles::offset($start)
                ->limit($limit)
                ->get();
        } else {
            $search = $request->input('search');

            $datas = Roles::where('name', 'LIKE', "%{$search}%")
                ->where('id', 'LIKE', "%{$search}%")
                ->offset($start)
                ->limit($limit)
                ->get();

            $totalFiltered = Roles::where('id', 'LIKE', "%{$search}%")
                ->where('name', 'LIKE', "%{$search}%")
                ->count();
        }

        $responseData = array();
        if (!empty($datas)) {
            foreach ($datas as $data) {
                $nestedData['id'] = $data->id;
                $nestedData['name'] = $data->name;
                $nestedData['active'] = $data->active;
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

    public function permissionDatatable(Request $request)
    {
        $totalData = Permissions::count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');

        if (empty($request->input('search'))) {
            $datas = Permissions::offset($start)
                ->limit($limit)
                ->get();
        } else {
            $search = $request->input('search');

            $datas = Permissions::where('name', 'LIKE', "%{$search}%")
                ->where('id', 'LIKE', "%{$search}%")
                ->offset($start)
                ->limit($limit)
                ->get();

            $totalFiltered = Permissions::where('id', 'LIKE', "%{$search}%")
                ->where('name', 'LIKE', "%{$search}%")
                ->count();
        }

        $roles = Roles::where('active', 1)->get();

        $responseData = array();
        if (!empty($datas)) {
            foreach ($datas as $data) {
                $nestedData['id'] = $data->id;
                $nestedData['name'] = $data->name;
                foreach ($roles as $role) {
                    $rolePermission = RolePermissions::where([
                        'id_role' => $role->id,
                        'id_permission' => $data->id,
                    ])->first();
                    $nestedData[$role->name] = $rolePermission != null ? 1 : 0;
                }
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

public function savepermission(Request $request){

        $v = Validator::make($request->all(), [
            'url' => 'required'
        ]);

        if ($v->fails()) {
            return response()->json([
                'error' => 1,
                'msg' => $v->errors()
            ]);
        }

        $id = $request->id;
        $url = $request->url;

        if ($id > 0){
            $permission = Permissions::findOrFail($id);
        }else{
            $permission = new Permissions();
        }
            $permission->name = $url;
            $permission->url = $url;
            $permission->type = 1;

        if ($permission->save()) {

            $rolePermission = RolePermissions::where('id_role', 1)
                                ->where('id_permission', $permission->id)->first();

            if(empty($rolePermission)){
                $rolePermission = new RolePermissions();
                $rolePermission->id_role = 1;
                $rolePermission->id_permission = $permission->id;
                $rolePermission->save();
            }

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

    public function save(Request $request)
    {
        $name = $request->name;
        $value = $request->value;
        $id = $request->id;

        $role = Roles::where("name", $name)->first();

        if ($value == 1) {
            $rolePermission = new RolePermissions();
            $rolePermission->id_role = $role->id;
            $rolePermission->id_permission = $id;
            $rolePermission->save();
        } else {
            RolePermissions::where([
                'id_permission' => $id,
                'id_role' => $role->id
            ])->delete();
        }

        return response()->json([
            'success' => 1,
            'msg' => "Successfully saved"
        ]);
    }

    public function deletepermission(Request $request){
        $id = $request->id;

        $permission = Permissions::findOrFail($id);
        if ($permission) {
            $permission->delete();
        }

        return response()->json([
            'success' => 1,
            'msg' => "Successfully deleted"
        ]);
    }

    public function getpermission(Request $request){
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
            $permission = Permissions::findOrFail($id);

        }

        if(!empty($permission)>0){
            return response()->json([
                'success' => 1,
                'msg' => "Success",
                'data' => $permission
            ]);
        }

        return response()->json([
            'success' => 0,
            'msg' => "No data available."
        ]);
    }
}
