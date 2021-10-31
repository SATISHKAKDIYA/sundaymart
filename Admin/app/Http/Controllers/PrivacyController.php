<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Privacy;
use App\Models\PrivacyLanguage;
use Illuminate\Support\Facades\Validator;


class PrivacyController extends Controller
{
    public function save(Request $request){
       
        $v = Validator::make($request->all(), [
            'active' => 'required',
            'id_shop' => 'required',
            'id_lang' => 'required'
        ]);

        if ($v->fails()) {
            return response()->json([
                'error' => 1,
                'msg' => $v->errors()
            ]);
        }

        $id = $request->id;
        $active = $request->active;
        $id_shop = $request->id_shop;
        $id_lang = $request->id_lang;
        $content = $request->content;
                
        if ($id > 0){
            $privacy = Privacy::findOrFail($id);
        }else{
            $privacy = new Privacy();
        }

        $privacy->active = $active;
        $privacy->id_shop = $id_shop;

        if ($id > 0)
            $privacy->updated_at = date("Y-m-d H:i:s");
        else
            $privacy->created_at = date("Y-m-d H:i:s");

        if ($privacy->save()) {

            if ($id > 0){
                $privacy_language = PrivacyLanguage::where('id_privacy', $id)->first();
            }else{
                $privacy_language = new PrivacyLanguage();
            }

            $privacy_language->id_privacy = $privacy->id;
            $privacy_language->id_lang = $id_lang;
            $privacy_language->content = $content;
            $privacy_language->save();

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
        $totalData = Privacy::count();

        $totalFiltered = 0;

        $limit = $request->input('length');
        $start = $request->input('start');

        $sort_field = 'privacy.id';
        $sort_type = 'asc';
            
        if (!empty($request->input('sort_field')))
        $sort_field = $request->input('sort_field');

        if (!empty($request->input('sort_type')))
        $sort_type = $request->input('sort_type');

        if (!empty($request->input('search')))
        $search = $request->input('search');

        $id_lang = $request->id_lang;

        $datas = Privacy::select("privacy.*", "privacy_language.*")
                ->join('privacy_language', 'privacy_language.id_privacy', '=', 'privacy.id')
                ->where([
                    'privacy_language.id_lang' => $id_lang,
                    'privacy.active' => 1
                ]);

                if(isset($search)){
                    $datas = $datas->where("privacy_language.content", "LIKE", "%{$search}%");
                }
                $datas = $datas->orderBy($sort_field, $sort_type)
                ->offset($start)
                ->limit($limit)
                ->get();

                if(isset($search)){
                    $totalFiltered = Privacy::select("privacy.*", "privacy_language.*")
                    ->join('privacy_language', 'privacy_language.id_privacy', '=', 'privacy.id')
                    ->where([
                        'privacy_language.id_lang' => $id_lang,
                        'privacy.active' => 1
                    ]);
    
                    if(isset($search)){
                        $datas = $datas->where("privacy_language.content", "LIKE", "%{$search}%");
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
                        "privacy" => $datas
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

        $privacy = Privacy::findOrFail($id);
        if ($privacy) {
            $privacy->delete();
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
        $id_lang = $request->id_lang;
                
        if ($id > 0){

            $privacy = Privacy::select("privacy.*", "privacy_language.*")
                ->join('privacy_language', 'privacy_language.id_privacy', '=', 'privacy.id')
                ->where([
                    'privacy_language.id_lang' => $id_lang,
                    'privacy.id' => $id
                ])->first();

        }

        if(!empty($privacy)){
            return response()->json([
                'success' => 1,
                'msg' => "Success",
                'data' => $privacy
            ]);
        }
           
        return response()->json([
            'success' => 0,
            'msg' => "No data available."
        ]);
    }
}
