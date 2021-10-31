<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class UploadController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:api', ['except' => ['upload']]);
    }

    public function upload(Request $request)
    {
        $file = $request->file('file');
        $destinationPath = public_path().'/uploads';
        $file_name = time()."_".$file->getClientOriginalName();
        if ($file->move($destinationPath, $file_name)) {
            return response()->json([
                'success' => 1,
                'name' => $file_name,
                'msg' => "Image uploaded"
            ]);
        }

        return response()->json([
            'success' => 0,
            'name' => $file_name,
            'msg' => "Error in image uploading"
        ]);
    }
}
