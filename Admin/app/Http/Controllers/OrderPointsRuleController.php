<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\OrderPointsRule;
use App\Models\OrderPointsRuleLanguage;
use App\Models\Languages;
use Illuminate\Support\Facades\Validator;


class OrderPointsRuleController extends Controller
{
    public function save(Request $request){
       
        $v = Validator::make($request->all(), [
            'active' => 'required|numeric',
            'id_lang' => 'required|numeric',
            'name' => 'required',
            'description' => 'required'
        ]);

        if ($v->fails()) {
            return response()->json([
                'error' => 1,
                'msg' => $v->errors()
            ]);
        }

        $id = $request->id;
        $active = $request->active;
        $id_lang = $request->id_lang;
        $name = $request->name;
        $description = $request->description;
                
        if ($id > 0){
            $rule = OrderPointsRule::findOrFail($id);
        }else{
            $rule = new OrderPointsRule();
        }
        $rule->active = $active;

        if ($id > 0)
            $rule->updated_at = date("Y-m-d H:i:s");
        else
            $rule->created_at = date("Y-m-d H:i:s");

        if ($rule->save()) {

            if ($id > 0){
                $rule_language = OrderPointsRuleLanguage::findOrFail($id);
            }else{
                $rule_language = new OrderPointsRuleLanguage();
            }

            $rule->id_lang = $id_lang;
            $rule->id_order_points_rule = $rule->id;
            $rule->name = $name;
            $rule->description = $description;

            $rule->save();

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
        $limit = $request->input('length');
        $start = $request->input('start');

        $sort_field = 'order_points_rule.id';
        $sort_type = 'asc';
            
        if (!empty($request->input('sort_field')))
        $sort_field = $request->input('sort_field');

        if (!empty($request->input('sort_type')))
        $sort_type = $request->input('sort_type');

        if (!empty($request->input('search')))
        $search = $request->input('search');

        $defaultLanguage = Languages::where("default", 1)->first();

        $datas = OrderPointsRule::select("order_points_rule.*", "order_points_rule_language.*")
                ->join('order_points_rule_language', 'order_points_rule_language.id_order_points_rule', '=', 'order_points_rule.id')
                ->where('order_points_rule_language.id_lang', $defaultLanguage);

                if(isset($search)){
                    $datas = $datas->where("order_points_rule_language.name", "LIKE", "%{$search}%")
                    ->where("order_points_rule_language.description", "LIKE", "%{$search}%");
                }
                $datas = $datas->orderBy($sort_field, $sort_type)
                ->offset($start)
                ->limit($limit)
                ->get();

                if(isset($search)){
                    $totalFiltered = OrderPointsRule::select("order_points_rule.*", "order_points_rule_language.*")
                    ->join('order_points_rule_language', 'order_points_rule_language.id_order_points_rule', '=', 'order_points_rule.id')
                    ->where('order_points_rule_language.id_lang', $defaultLanguage);
    
                    if(isset($search)){
                        $totalFiltered = $totalFiltered->where("order_points_rule_language.name", "LIKE", "%{$search}%")
                        ->where("order_points_rule_language.description", "LIKE", "%{$search}%");
                    }
                    $totalFiltered = $totalFiltered->orderBy($sort_field, $sort_type)
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
                        "rules" => $datas
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

        $rule = OrderPointsRule::findOrFail($id);
        if ($rule) {
            $rule->delete();
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
        $defaultLanguage = Languages::where("default", 1)->first();

        if ($id > 0){
            $rule = OrderPointsRule::where('id', $id)->first();

            $rule = OrderPointsRule::select("order_points_rule.*", "order_points_rule_language.*")
                ->join('order_points_rule_language', 'order_points_rule_language.id_order_points_rule', '=', 'order_points_rule.id')
                ->where('order_points_rule_language.id_lang', $defaultLanguage)
                -where('order_points_rule.id', $id)
                ->first();
        }

        if(!empty($rule)){
            return response()->json([
                'success' => 1,
                'msg' => "Success",
                'data' => $rule
            ]);
        }
           
        return response()->json([
            'success' => 0,
            'msg' => "No data available."
        ]);
    }
}
