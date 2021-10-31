<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Terms;
use App\Models\TermsLanguage;
use Illuminate\Support\Facades\Validator;


class TermsController extends Controller
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
            $terms = Terms::findOrFail($id);
        }else{
            $terms = new Terms();
        }

        $terms->active = $active;
        $terms->id_shop = $id_shop;

        if ($id > 0)
            $terms->updated_at = date("Y-m-d H:i:s");
        else
            $terms->created_at = date("Y-m-d H:i:s");

        if ($terms->save()) {

            if ($id > 0){
                $terms_language = TermsLanguage::where('id_privacy', $id)->first();
            }else{
                $terms_language = new TermsLanguage();
            }

            $terms_language->id_terms = $terms->id;
            $terms_language->id_lang = $id_lang;
            $terms_language->content = $content;
            $terms_language->save();

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
        $totalData = Terms::count();

        $totalFiltered = 0;

        $limit = $request->input('length');
        $start = $request->input('start');

        $sort_field = 'terms.id';
        $sort_type = 'asc';
            
        if (!empty($request->input('sort_field')))
        $sort_field = $request->input('sort_field');

        if (!empty($request->input('sort_type')))
        $sort_type = $request->input('sort_type');

        if (!empty($request->input('search')))
        $search = $request->input('search');

        $id_lang = $request->id_lang;

        $datas = Terms::select("terms.*", "terms_language.*")
                ->join('terms_language', 'terms_language.id_terms', '=', 'terms.id')
                ->where([
                    'terms_language.id_lang' => $id_lang,
                    'terms.active' => 1
                ]);

                if(isset($search)){
                    $datas = $datas->where("terms_language.content", "LIKE", "%{$search}%");
                }
                $datas = $datas->orderBy($sort_field, $sort_type)
                ->offset($start)
                ->limit($limit)
                ->get();

                if(isset($search)){
                    $totalFiltered = Terms::select("terms.*", "terms_language.*")
                    ->join('terms_language', 'terms_language.id_terms', '=', 'terms.id')
                    ->where([
                        'terms_language.id_lang' => $id_lang,
                        'terms.active' => 1
                    ]);
    
                    if(isset($search)){
                        $datas = $datas->where("terms_language.content", "LIKE", "%{$search}%");
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
                        "terms" => $datas
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

        $terms = Terms::findOrFail($id);
        if ($terms) {
            $terms->delete();
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

            $terms = Terms::select("terms.*", "terms_language.*")
                ->join('terms_language', 'terms_language.id_terms', '=', 'terms.id')
                ->where([
                    'terms_language.id_lang' => $id_lang,
                    'terms.id' => $id
                ])->first();

        }

        if(!empty($terms)){
            return response()->json([
                'success' => 1,
                'msg' => "Success",
                'data' => $terms
            ]);
        }
           
        return response()->json([
            'success' => 0,
            'msg' => "No data available."
        ]);
    }
}
