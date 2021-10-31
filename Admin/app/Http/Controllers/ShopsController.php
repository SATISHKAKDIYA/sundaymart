<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Languages;
use App\Models\Shops;
use App\Models\Admin;
use App\Models\ShopsLanguage;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;

class ShopsController extends Controller
{
   use ApiResponse;

    public function save(Request $request)
    {
        $names = $request->names;
        $descriptions = $request->descriptions;
        $addresses = $request->addresses;
        $infos = $request->infos;
        $latitude = $request->latitude;
        $longitude = $request->longitude;
        $commission = $request->commission;
        $delivery_fee = $request->delivery_fee;
        $delivery_range = $request->delivery_range;
        $mobile = $request->mobile;
        $phone = $request->phone;
        $tax = $request->tax;
        $close_hours = $request->close_hours;
        $open_hours = $request->open_hours;
        $active = $request->active;
        $delivery_type = $request->delivery_type;
        $is_closed = $request->is_closed;
        $feature_type = $request->feature_type;
        $logo_url = $request->logo_url;
        $back_image_url = $request->back_image_url;
        $id = $request->id;
        $shop_categories_id = $request->shop_categories_id;

        if ($id > 0)
            $shops = Shops::findOrFail($id);
        else
            $shops = new Shops();
        $shops->logo_url = $logo_url;
        $shops->backimage_url = $back_image_url;
        $shops->delivery_type = $delivery_type;
        $shops->delivery_price = $delivery_fee;
        $shops->delivery_range = $delivery_range;
        $shops->tax = $tax;
        $shops->admin_percentage = $commission;
        $shops->latitude = $latitude;
        $shops->longtitude = $longitude;
        $shops->phone = $phone;
        $shops->mobile = $mobile;
        $shops->show_type = $feature_type;
        $shops->is_closed = $is_closed;
        $shops->active = $active;
        $shops->open_hour = $open_hours;
        $shops->close_hour = $close_hours;
        $shops->id_shop_category = $shop_categories_id;
        if ($id > 0)
            $shops->updated_at = date("Y-m-d H:i:s");
        else
            $shops->created_at = date("Y-m-d H:i:s");
        if ($shops->save()) {
            $shops_id = $shops->id;
            foreach ($names as $key => $value) {
                $language = Languages::where("short_name", $key)->first();

                if ($id > 0) {
                    $shopsLanguage = ShopsLanguage::where([
                        "id_shop" => $id,
                        "id_lang" => $language->id
                    ])->first();
                    if (!$shopsLanguage)
                        $shopsLanguage = new ShopsLanguage();
                } else
                    $shopsLanguage = new ShopsLanguage();
                $shopsLanguage->name = $value;
                $shopsLanguage->description = $descriptions[$key];
                $shopsLanguage->info = $infos[$key];
                $shopsLanguage->address = $addresses[$key];
                $shopsLanguage->id_lang = $language->id;
                $shopsLanguage->id_shop = $shops_id;
                $shopsLanguage->save();
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
        $totalData = Shops::count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');

        $defaultLanguage = Languages::where("default", 1)->first();

        $shop_id = Admin::getUserShopId();

        if (empty($request->input('search'))) {

            $datas = Shops::select("shops.*", "shops_language.name", "shops_language.description", "shop_categories_language.name as shop_categories_language_name")->offset($start)
                ->join('shops_language', 'shops_language.id_shop', '=', 'shops.id')
                ->join('shop_categories', 'shop_categories.id', '=', 'shops.id_shop_category')
                ->join('shop_categories_language', 'shop_categories_language.id_shop_category', '=', 'shop_categories.id')
                ->where('shops_language.id_lang', $defaultLanguage->id)
                ->where('shop_categories_language.id_lang', $defaultLanguage->id);

            if ($shop_id != -1) {
                $datas = $datas->where('shops.id', $shop_id);
            }

            $datas = $datas->limit($limit)
                ->get();

        } else {
            $search = $request->input('search');

            $datas = Shops::select("shops.*", "shops_language.name", "shops_language.description", "shop_categories_language.name as shop_categories_language_name")->offset($start)
                ->join('shops_language', 'shops_language.id_shop', '=', 'shops.id')
                ->join('shop_categories', 'shop_categories.id', '=', 'shops.id_shop_category')
                ->join('shop_categories_language', 'shop_categories_language.id_shop_category', '=', 'shop_categories.id')
                ->where('shops_language.name', 'LIKE', "%{$search}%")
                ->where('shops_language.id_lang', $defaultLanguage->id)
                ->where('shop_categories_language.id_lang', $defaultLanguage->id);
            if ($shop_id != -1) {
                $datas = $datas->where('shops.id', $shop_id);
            }

            $datas = $datas->limit($limit)
                ->get();

            $totalFiltered = Shops::select("shops.*", "shops_language.name", "shops_language.description", "shop_categories_language.name as shop_categories_language_name")->offset($start)
                ->join('shops_language', 'shops_language.id_shop', '=', 'shops.id')
                ->join('shop_categories', 'shop_categories.id', '=', 'shops.id_shop_category')
                ->join('shop_categories_language', 'shop_categories_language.id_shop_category', '=', 'shop_categories.id')
                ->where('shops_language.name', 'LIKE', "%{$search}%")
                ->where('shops_language.id_lang', $defaultLanguage->id)
                ->where('shop_categories_language.id_lang', $defaultLanguage->id);
            if ($shop_id != -1) {
                $datas = $datas->where('shops.id', $shop_id);
            }

            $datas = $datas->limit($limit)
                ->count();
        }

        $responseData = array();
        if (!empty($datas)) {
            foreach ($datas as $data) {
                $nestedData['id'] = $data->id;
                $nestedData['name'] = $data->name;
                $nestedData['shop_categories_language_name'] = $data->shop_categories_language_name;
                $nestedData['description'] = $data->description;
                $nestedData['back_image'] = $data->backimage_url;
                $nestedData['logo'] = $data->logo_url;
                $nestedData['delivery_type'] = $data->delivery_type;
                $nestedData['delivery_fee'] = $data->delivery_price;
                $nestedData['delivery_range'] = $data->delivery_range;
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


    public function get(Request $request)
    {
        $id = $request->id;
        $shops = Shops::findOrFail($id);
        $shops_language = ShopsLanguage::select("shops_language.*", "language.short_name")->where("id_shop", $id)
            ->join('language', 'language.id', '=', 'shops_language.id_lang')
            ->get();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => [
                "shop" => $shops,
                "shops_language" => $shops_language
            ]
        ]);
    }

    public function delete(Request $request)
    {
        $id = $request->id;

        $shop_id = Admin::getUserShopId();

        if ($shop_id == -1) {
            $shop = Shops::findOrFail($id);
            if ($shop) {
                $shop->delete();
            }
        }

        return response()->json([
            'success' => 1,
            'msg' => "Successfully deleted"
        ]);
    }

    public function active(Request $request)
    {
        $defaultLanguage = Languages::where("default", 1)->first();

        $shops = Shops::select("shops.id", "shops.delivery_price", "shops.tax", "shops_language.name")
            ->join('shops_language', 'shops_language.id_shop', '=', 'shops.id')
            ->where([
                'shops_language.id_lang' => $defaultLanguage->id,
                'active' => 1
            ])
            ->get();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => $shops
        ]);
    }

    public function getTotalShopsCount() {
        $count = Shops::count();

        return $this->successResponse("success", $count);
    }
}
