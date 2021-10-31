<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Currency;
use App\Models\CurrencyLanguage;
use App\Models\Languages;

class CurrencyController extends Controller
{
    public function save(Request $request)
    {
        $id = $request->id;
        $symbol = $request->symbol;
        $active = $request->active;
        $names = $request->name;

        if ($id > 0)
            $currency = Currency::findOrFail($id);
        else
            $currency = new Currency();

        $currency->symbol = $symbol;
        $currency->active = $active;

        if ($id > 0)
            $currency->updated_at = date("Y-m-d H:i:s");
        else
            $currency->created_at = date("Y-m-d H:i:s");

        if ($currency->save()) {
            $currency_id = $currency->id;
            foreach ($names as $key => $value) {
                $language = Languages::where("short_name", $key)->first();

                if ($id > 0) {
                    $currencyLanguage = CurrencyLanguage::where([
                        "id_currency" => $id,
                        "id_lang" => $language->id
                    ])->first();
                    if (!$currencyLanguage)
                        $currencyLanguage = new CurrencyLanguage();
                } else
                    $currencyLanguage = new CurrencyLanguage();
                    $currencyLanguage->name = $value;
                    $currencyLanguage->id_currency = $currency_id;
                    $currencyLanguage->id_lang = $language->id;
                    $currencyLanguage->save();
            }

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
        $totalData = Currency::count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');

        $defaultLanguage = Languages::where("default", 1)->first();

        if (empty($request->input('search'))) {
            $datas = Currency::select("currency.*", "currency_language.name")
                ->join('currency_language', 'currency_language.id_currency', '=', 'currency.id')
                ->where('currency_language.id_lang', $defaultLanguage->id)
                ->offset($start)
                ->limit($limit)
                ->get();
        } else {
            $search = $request->input('search');

            $datas = Currency::select("currency.*", "currency_language.name")
                ->join('currency_language', 'currency_language.id_currency', '=', 'currency.id')
                ->where('currency_language.id_lang', $defaultLanguage->id)
                ->where('name', 'LIKE', "%{$search}%")
                ->where('id', 'LIKE', "%{$search}%")
                ->offset($start)
                ->limit($limit)
                ->get();

            $totalFiltered = Currency::select("currency.*", "currency_language.name")
                ->join('currency_language', 'currency_language.id_currency', '=', 'currency.id')
                ->where('currency_language.id_lang', $defaultLanguage->id)
                ->where('name', 'LIKE', "%{$search}%")
                ->where('id', 'LIKE', "%{$search}%")
                ->offset($start)
                ->limit($limit)
                ->count();
        }

        $responseData = array();
        if (!empty($datas)) {
            foreach ($datas as $data) {

                $nestedData['id'] = $data->id;
                $nestedData['symbol'] = $data->symbol;
                $nestedData['active'] = $data->active;
                $nestedData['name'] = $data->name;
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


    public function get(Request $request)
    {
        $id = $request->id;
        $currency = Currency::findOrFail($id);
        $currency_language = CurrencyLanguage::select("currency_language.*", "language.short_name")
            ->where("id_currency", $id)
            ->join('language', 'language.id', '=', 'currency_language.id_lang')
            ->get();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => [
                "currency" => $currency,
                "currency_language" => $currency_language
            ]
        ]);
    }

    public function delete(Request $request)
    {
        $id = $request->id;

        $currency = Currency::findOrFail($id);
        if ($currency) {
            $currency->delete();
        }

        return response()->json([
            'success' => 1,
            'msg' => "Successfully deleted"
        ]);
    }

    public function active(Request $request)
    {
        $defaultLanguage = Languages::where("default", 1)->first();

        $currencies = Currency::select("currency.id", "currency_language.name")
            ->join('currency_language', 'currency_language.id_currency', '=', 'currency.id')
            ->where([
                'currency_language.id_lang' => $defaultLanguage->id,
                'currency.active' => 1,
            ])
            ->get();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => $currencies
        ]);
    }
}
