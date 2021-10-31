<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Banners;
use App\Models\BannersLanguage;
use App\Models\BannersProducts;
use App\Models\Languages;
use App\Models\Admin;

use Illuminate\Http\Request;

class BannerController extends Controller
{
    public function save(Request $request)
    {
        $name = $request->name;
        $description = $request->description;
        $sub_title = $request->sub_title;
        $button_text = $request->button_text;
        $products = $request->products;
        $position = $request->position;
        $shop_id = $request->shop_id;
        $image_path = $request->image_path;
        $title_color = $request->title_color;
        $button_color = $request->button_color;
        $indicator_color = $request->indicator_color;
        $background_color = $request->background_color;
        $active = $request->active;
        $id = $request->id;

        if ($id > 0)
            $banners = Banners::findOrFail($id);
        else
            $banners = new Banners();

        $banners->image_url = $image_path;
        $banners->title_color = $title_color;
        $banners->button_color = $button_color;
        $banners->indicator_color = $indicator_color;
        $banners->background_color = $background_color;
        $banners->position = $position;
        $banners->active = $active;
        $banners->id_shop = $shop_id;
        if ($id > 0)
            $banners->updated_at = date("Y-m-d H:i:s");
        else
            $banners->created_at = date("Y-m-d H:i:s");

        if ($banners->save()) {
            $banner_id = $banners->id;
            foreach ($name as $key => $value) {
                $language = Languages::where("short_name", $key)->first();

                if ($id > 0) {
                    $bannersLanguage = BannersLanguage::where([
                        "id_banner" => $banner_id,
                        "id_lang" => $language->id
                    ])->first();
                    if (!$bannersLanguage)
                        $bannersLanguage = new BannersLanguage();
                } else
                    $bannersLanguage = new BannersLanguage();

                $bannersLanguage->title = $value;
                $bannersLanguage->description = $description[$key];
                $bannersLanguage->sub_title = $sub_title[$key];
                $bannersLanguage->button_text = $button_text[$key];
                $bannersLanguage->id_banner = $banner_id;
                $bannersLanguage->id_lang = $language->id;
                $bannersLanguage->save();
            }


            BannersProducts::where("id_banner", $banner_id)->delete();

            if (is_array($products) && count($products) > 0)
                foreach ($products as $productId) {
                    $bannerProduct = new BannersProducts();
                    $bannerProduct->id_banner = $banner_id;
                    $bannerProduct->id_product = intval($productId);
                    if(!$bannerProduct->save()) {
                        return response()->json([
                            'success' => 0,
                            'msg' => "Successfully saved"
                        ]);
                    }
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
        $totalData = Banners::count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');

        $defaultLanguage = Languages::where("default", 1)->first();

        $shop_id = Admin::getUserShopId();

        if (empty($request->input('search'))) {
            $datas = Banners::select("banners.*",
                "banners_language.title",
                "banners_language.description",
                "banners_language.button_text",
                "banners_language.sub_title",
                'shops_language.name')
                ->join('banners_language', 'banners_language.id_banner', '=', 'banners.id')
                ->join('shops_language', 'shops_language.id_shop', '=', 'banners.id_shop')
                ->where('banners_language.id_lang', $defaultLanguage->id)
                ->where('shops_language.id_lang', $defaultLanguage->id);
                if($shop_id != -1){
                    $datas = $datas->where('banners.id_shop', $shop_id);
                 }

                 $datas = $datas
                ->offset($start)
                ->limit($limit)
                ->get();
        } else {
            $search = $request->input('search');

            $datas = Banners::select("banners.*",
                "banners_language.title",
                "banners_language.description",
                "banners_language.button_text",
                "banners_language.sub_title",
                'shops_language.name')
                ->join('banners_language', 'banners_language.id_banner', '=', 'banners.id')
                ->join('shops_language', 'shops_language.id_shop', '=', 'banners.id_shop')
                ->where('banners_language.id_lang', $defaultLanguage->id)
                ->where('shops_language.id_lang', $defaultLanguage->id)
                ->where('name', 'LIKE', "%{$search}%")
                ->where('id', 'LIKE', "%{$search}%");
                if($shop_id != -1){
                    $datas = $datas->where('banners.id_shop', $shop_id);
                 }

                 $datas = $datas
                ->offset($start)
                ->limit($limit)
                ->get();

            $totalFiltered = Banners::select("banners.*",
                "banners_language.title",
                "banners_language.description",
                "banners_language.button_text",
                "banners_language.sub_title",
                'shops_language.name')
                ->join('banners_language', 'banners_language.id_banner', '=', 'banners.id')
                ->join('shops_language', 'shops_language.id_shop', '=', 'banners.id_shop')
                ->where('banners_language.id_lang', $defaultLanguage->id)
                ->where('shops_language.id_lang', $defaultLanguage->id)
                ->where('id', 'LIKE', "%{$search}%")
                ->where('name', 'LIKE', "%{$search}%");
                if($shop_id != -1){
                    $datas = $datas->where('banners.id_shop', $shop_id);
                 }

                 $datas = $datas
                ->count();
        }

        $responseData = array();
        if (!empty($datas)) {
            foreach ($datas as $data) {
                $nestedData['id'] = $data->id;
                $nestedData['name'] = $data->title;
                $nestedData['description'] = $data->description;
                $nestedData['sub_title'] = $data->sub_title;
                $nestedData['button_text'] = $data->button_text;
                $nestedData['image_url'] = $data->image_url;
                $nestedData['title_color'] = $data->title_color;
                $nestedData['button_color'] = $data->button_color;
                $nestedData['indicator_color'] = $data->indicator_color;
                $nestedData['background_color'] = $data->background_color;
                $nestedData['position'] = $data->position;
                $nestedData['shop'] = $data->name;
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
        $banner = Banners::find($id);

        if ($banner) {
            $banner->delete();
        }

        return response()->json([
            'success' => 1,
            'msg' => "Successfully deleted"
        ]);
    }

    public function get(Request $request)
    {
        $id = $request->id;
        $banner = Banners::findOrFail($id);
        $banner_language = BannersLanguage::select("banners_language.*", "language.short_name")->where("id_banner", $id)
            ->join('language', 'language.id', '=', 'banners_language.id_lang')
            ->get();

        $banner_products = BannersProducts::select("banners_products.*")->where("id_banner", $id)
            ->get();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => [
                "banner" => $banner,
                "banner_language" => $banner_language,
                'banner_products' => $banner_products
            ]
        ]);
    }
}
