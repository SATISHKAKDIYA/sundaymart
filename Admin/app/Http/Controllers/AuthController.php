<?php

namespace App\Http\Controllers;

use App\Models\RolePermissions;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Tymon\JWTAuth\Facades\JWTAuth;

class AuthController extends Controller {
    public function __construct()
    {
        $this->middleware('auth:api', ['except' => ['login', 'create', 'activate', 'createmanager' ]]);
    }


    public function login(Request $request)
    {
        $v = Validator::make($request->all(), [
            'email' => 'required',
            'password' => 'required',
        ], [
            'email.required' => 'Email is required',
            'password.required' => "Password is required",
        ]);

        if ($v->fails()) {
            return response()->json([
                'error' => 1,
                'msg' => $v->errors()
            ]);
        }

        $email = $request->email;
        $password = $request->password;

        if (Auth::attempt(['email' => $email, 'password' => $password])) {
            $token = JWTAuth::attempt(["email" => $email, 'password' => $password]);
            $user = Auth::user();
            $permissions = RolePermissions::select('name', 'url')->where('id_role', $user['id_role'])
                ->join('permissions', 'permissions.id', '=', 'roles_permissions.id_permission')
                ->get();

            return response()->json([
                'success' => 1,
                'msg' => "Success",
                'token' => $token,
                'data' => $user,
                'permissions' => $permissions
            ]);
        } else {
            return response()->json([
                'success' => 0,
                'msg' => "Email or password is incorrect."
            ]);
        }
    }
}
