<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\Media;
use Illuminate\Support\Facades\DB;

class MediaController extends Controller
{
    public function media(Request $request){
        $limit = $request->input('length');
        $start = $request->input('start');

        $allfiles = Media::files($limit, $start);

        $responseData = array();
        if (!empty($allfiles)) {
            foreach ($allfiles['data'] as $data) {

                $nestedData['file'] = $data['file'];
                $nestedData['info'] = $this->getInfo($data['file']);
                $nestedData['options'] = [
                    'delete' => 1,
                    'info' => 1,
                ];
                $responseData[] = $nestedData;

            }
        }

        $json_data = array(
            "total" => intval($allfiles['count']),
            "filtered" => intval(count($responseData)),
            "data" => $responseData
        );

        return response()->json($json_data);
    }

    public function delete(Request $request){

        $v = Validator::make($request->all(), [
            'url' => 'required'
        ]);

        if ($v->fails()) {
            return response()->json([
                'error' => 1,
                'msg' => $v->errors()
            ]);
        }

        $path = public_path().'/uploads';
        //$path = base_path()."/uploads";

        // delete image file
        $filename = $path.'/'.$request->url;

        if(\File::exists($filename)){
            if(\File::delete($filename)){
                return response()->json([
                    'success' => 1,
                    'msg' => "Successfully deleted file"
                ]);
            } else {
                return response()->json([
                    'success' => 0,
                    'msg' => "Failed to delete a file"
                ]);
            }
          }else{

            return response()->json([
                'success' => 0,
                'msg' => "File not exist"
            ]);

          }

    }

    // function to check filename exists or not in one of the tables
    public function getInfo($url){
        $tables = ['admins', 'banners', 'brands', 'categories', 'clients',
                    'language', 'notifications', 'product_extras', 'products_images',
                    'shops'];

        $tablename = '';
        foreach ($tables as $table) {
            if($table == 'shops'){
                $result = DB::table($table)->where('logo_url', $url)->first();
                if(empty($result)){
                    $result = DB::table($table)->where('backimage_url', $url)->first();
                }
            } else {
                $result = DB::table($table)->where('image_url', $url)->first();
            }

            if($result){
                $tablename = $table;
                break;
            }
        }

        if($tablename != ''){
            return $tablename;
        } else {
            return "-";

        }
    }

}
