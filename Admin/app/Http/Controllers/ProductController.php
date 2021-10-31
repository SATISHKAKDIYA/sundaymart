<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Languages;
use App\Models\Products;
use App\Models\ProductsComment;
use App\Models\ProductsImages;
use App\Models\ProductsLanguage;
use App\Models\Admin;

use App\Traits\ApiResponse;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    use ApiResponse;

    public function save(Request $request)
    {
        $names = $request->names;
        $descriptions = $request->descriptions;
        $shop_id = $request->shop_id;
        $brand_id = $request->brand_id;
        $category_id = $request->category_id;
        $package_count = $request->package_count;
        $price = $request->price;
        $quantity = $request->quantity;
        $unit = $request->unit;
        $weight = $request->weight;
        $feature_type = $request->feature_type;
        $images = $request->images;
        $active = $request->active;
        $id = $request->id;

        if ($id > 0)
            $product = Products::findOrFail($id);
        else
            $product = new Products();

        $product->quantity = $quantity;
        $product->pack_quantity = $package_count;
        $product->weight = $weight;
        $product->price = $price;
        $product->show_type = $feature_type;
        $product->active = $active;
        $product->id_unit = $unit;
        $product->id_category = $category_id;
        $product->id_shop = $shop_id;
        $product->id_brand = $brand_id;
        if ($id > 0)
            $product->updated_at = date("Y-m-d H:i:s");
        else
            $product->created_at = date("Y-m-d H:i:s");

        if ($product->save()) {
            $product_id = $product->id;
            foreach ($names as $key => $value) {
                $language = Languages::where("short_name", $key)->first();

                if ($id > 0) {
                    $productLanguage = ProductsLanguage::where([
                        "id_product" => $id,
                        "id_lang" => $language->id
                    ])->first();
                    if (!$productLanguage)
                        $productLanguage = new ProductsLanguage();
                } else
                    $productLanguage = new ProductsLanguage();
                $productLanguage->name = $value;
                $productLanguage->description = $descriptions[$key];
                $productLanguage->id_product = $product_id;
                $productLanguage->id_lang = $language->id;
                $productLanguage->save();
            }

            ProductsImages::where("id_product", $product_id)->delete();

            foreach ($images as $key => $image) {
                $productImage = new ProductsImages();
                $productImage->image_url = $image['name'];
                $productImage->id_product = $product_id;
                if ($key == 0)
                    $productImage->main = 1;
                else
                    $productImage->main = 0;
                $productImage->save();
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
        $totalData = Products::count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');

        $defaultLanguage = Languages::where("default", 1)->first();

        $shop_id = Admin::getUserShopId();

        if (empty($request->input('search'))) {
            $datas = Products::select("products.*", "products_language.name", "products_language.description", "shops_language.name as shop_name", "categories_language.name as category_name", "brands.name as brand_name", "products_images.image_url")->offset($start)
                ->join('products_language', 'products_language.id_product', '=', 'products.id')
                ->join('shops_language', 'shops_language.id_shop', '=', 'products.id_shop')
                ->join('categories_language', 'categories_language.id_category', '=', 'products.id_category')
                ->join('brands', 'brands.id', '=', 'products.id_brand')
                ->join('products_images', 'products_images.id_product', '=', 'products.id')
                ->where([
                    'products_language.id_lang' => $defaultLanguage->id,
                    'shops_language.id_lang' => $defaultLanguage->id,
                    'categories_language.id_lang' => $defaultLanguage->id,
                    'products_images.main' => 1
                ]);
            if ($shop_id != -1) {
                $datas = $datas->where('products.id_shop', $shop_id);
            }
            $datas = $datas
                ->limit($limit)
                ->orderBy("products.id", "desc")
                ->get();
        } else {
            $search = $request->input('search');

            $datas = Products::select("products.*", "products_language.name", "products_language.description", "shops_language.name as shop_name", "categories_language.name as category_name", "brands.name as brand_name", "products_images.image_url")->where('id', 'LIKE', "%{$search}%")
                ->join('products_language', 'products_language.id_product', '=', 'products.id')
                ->where('products_language.name', 'LIKE', "%{$search}%")
                ->join('shops_language', 'shops_language.id_shop', '=', 'products.id_shop')
                ->join('categories_language', 'categories_language.id_category', '=', 'products.id_category')
                ->join('brands', 'brands.id', '=', 'products.id_brand')
                ->join('products_images', 'products_images.id_product', '=', 'products.id')
                ->where([
                    'products_language.id_lang' => $defaultLanguage->id,
                    'shops_language.id_lang' => $defaultLanguage->id,
                    'categories_language.id_lang' => $defaultLanguage->id,
                    'products_images.main' => 1
                ]);
            if ($shop_id != -1) {
                $datas = $datas->where('products.id_shop', $shop_id);
            }
            $datas = $datas
                ->offset($start)
                ->limit($limit)
                ->get();

            $totalFiltered = Products::select("products.*", "products_language.name", "products_language.description", "shops_language.name as shop_name", "categories_language.name as category_name", "brands.name as brand_name", "products_images.image_url")->where('id', 'LIKE', "%{$search}%")
                ->join('products_language', 'products_language.id_product', '=', 'products.id')
                ->orWhere('products_language.name', 'LIKE', "%{$search}%")
                ->join('shops_language', 'shops_language.id_shop', '=', 'products.id_shop')
                ->join('categories_language', 'categories_language.id_category', '=', 'products.id_category')
                ->join('brands', 'brands.id', '=', 'products.id_brand')
                ->join('products_images', 'products_images.id_product', '=', 'products.id')
                ->where([
                    'products_language.id_lang' => $defaultLanguage->id,
                    'shops_language.id_lang' => $defaultLanguage->id,
                    'categories_language.id_lang' => $defaultLanguage->id,
                    'products_images.main' => 1
                ]);
            if ($shop_id != -1) {
                $datas = $datas->where('products.id_shop', $shop_id);
            }
            $datas = $datas
                ->count();
        }

        $responseData = array();
        if (!empty($datas)) {
            foreach ($datas as $data) {
                $nestedData['id'] = $data->id;
                $nestedData['name'] = substr($data->name, 0, 50) . (strlen($data->name) > 50 ? "..." : "");
                $nestedData['description'] = $data->description;
                $nestedData['image_url'] = $data->image_url;
                $nestedData['shop'] = $data->shop_name;
                $nestedData['category'] = $data->category_name;
                $nestedData['brand'] = $data->brand_name;
                $nestedData['amount'] = $data->quantity;
                $nestedData['price'] = $data->price;
                $nestedData['weight'] = $data->weight;
                $nestedData['show_type'] = $data->show_type;
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
        $product = Products::findOrFail($id);
        $product_language = ProductsLanguage::select("products_language.*", "language.short_name")->where("id_product", $id)
            ->join('language', 'language.id', '=', 'products_language.id_lang')
            ->get();

        $product_image = ProductsImages::select("products_images.image_url")->where("id_product", $id)
            ->get();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => [
                "product" => $product,
                "product_language" => $product_language,
                'product_image' => $product_image
            ]
        ]);
    }

    public function delete(Request $request)
    {
        $id = $request->id;
        if (is_array($id)) {
            Products::whereIn("id", $id)->delete();
        } else {
            $product = Products::findOrFail($id);

            if ($product) {
                $product->delete();
            }
        }

        return response()->json([
            'success' => 1,
            'msg' => "Successfully deleted"
        ]);
    }

    public function commentsDelete(Request $request)
    {
        $id = $request->id;

        $shop = ProductsComment::findOrFail($id);
        if ($shop) {
            $shop->delete();
        }

        return response()->json([
            'success' => 1,
            'msg' => "Successfully deleted"
        ]);
    }

    public function commentsDatatable(Request $request)
    {
        $totalData = ProductsComment::count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');

        $defaultLanguage = Languages::where("default", 1)->first();

        if (empty($request->input('search'))) {
            $datas = ProductsComment::select('products_comments.*', 'products_language.name as product_name', 'clients.name', 'clients.surname')
                ->join('products_language', 'products_language.id_product', '=', 'products_comments.id_product')
                ->join('clients', 'clients.id', '=', 'products_comments.id_user')
                ->where('products_language.id_lang', $defaultLanguage->id)
                ->offset($start)
                ->limit($limit)
                ->get();
        } else {
            $search = $request->input('search');

            $datas = ProductsComment::select('products_comments.*', 'products_language.name as product_name', 'clients.name', 'clients.surname')
                ->join('products_language', 'products_language.id_product', '=', 'products_comments.id_product')
                ->join('clients', 'clients.id', '=', 'products_comments.id_user')
                ->where('products_language.id_lang', $defaultLanguage->id)
                ->where('comment_text', 'LIKE', "%{$search}%")
                ->where('id', 'LIKE', "%{$search}%")
                ->offset($start)
                ->limit($limit)
                ->get();

            $totalFiltered = ProductsComment::select('products_comments.*', 'products_language.name as product_name', 'clients.name', 'clients.surname')
                ->join('products_language', 'products_language.id_product', '=', 'products_comments.id_product')
                ->join('clients', 'clients.id', '=', 'products_comments.id_user')
                ->where('products_language.id_lang', $defaultLanguage->id)
                ->where('id', 'LIKE', "%{$search}%")
                ->where('comment_text', 'LIKE', "%{$search}%")
                ->count();
        }

        $responseData = array();
        if (!empty($datas)) {
            foreach ($datas as $data) {
                $nestedData['id'] = $data->id;
                $nestedData['client'] = $data->name . " " . $data->surname;
                $nestedData['product'] = $data->product_name;
                $nestedData['text'] = $data->comment_text;
                $nestedData['star'] = $data->star;
                $nestedData['active'] = $data->active;
                $nestedData['options'] = [
                    'delete' => 1,
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

    public function active(Request $request)
    {
        $shop_id = $request->shop_id;

        $defaultLanguage = Languages::where("default", 1)->first();

        $products = Products::select("products.id", "products_language.name")->where("id_shop", $shop_id)
            ->join('products_language', 'products_language.id_product', '=', 'products.id')
            ->where('products_language.id_lang', $defaultLanguage->id)
            ->get();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => $products
        ]);
    }

    public function getTotalProductsCount() {
        $count = Products::count();

        return $this->successResponse("success", $count);
    }
}
