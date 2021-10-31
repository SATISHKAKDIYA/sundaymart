<?php

namespace App\Repositories;

use App\Models\Banners;
use App\Models\BannersProducts;
use App\Models\Shops as Model;
use App\Repositories\Interfaces\BannerInterface;
use App\Traits\ApiResponse;

class BannerRepository extends CoreRepository implements BannerInterface
{
    use ApiResponse;

    public function __construct()
    {
        parent::__construct();
    }


    protected function getModelClass()
    {
        $this->model = Model::class;
    }

    public function delete($id)
    {

    }

    public function createOrUpdate($collection = [])
    {

    }

    public function get($id_shop)
    {
    }

    public function getBannerForRest($id_shop, $id_lang)
    {
        $banners = Banners::with([
            "language" => function ($query) use ($id_lang) {
                $query->id_lang = $id_lang;
            }
        ])
            ->where('id_shop', $id_shop)
            ->get();

        return $this->successResponse("success", $banners);
    }

    public function getBannerProductsForRest($collection = []) {
        $banner = BannersProducts::where("id_banner", $collection['id_banner'])->with([
            "product" => function ($query) {
            },
            "product.images",
            "product.units.language" => function ($query) use ($collection) {
                $query->id_lang = $collection['id_lang'];
            },
            "product.discount.discount",
            "product.coupon.coupon",
            "product.language" => function ($query) use ($collection) {
                $query->where([
                    'id_lang' => $collection['id_lang'],
                    ['name', '!=', null]
                ]);
                $query->orWhere([
                    ['name', '!=', null]
                ]);
            }
        ])
            ->whereHas("product.language", function ($query) use ($collection) {
                if (strlen($collection['search']) >= 3) {
                    $query->where("name", "like", "%" . $collection['search'] . "%");
                }
            })
            ->whereHas("product", function ($query) use ($collection) {
                if (strlen($collection['brands']) > 0) {
                    $query->whereIn("id_brand", explode(",", $collection['brands']));
                }

                $whereQuery = [
                    "active" => 1,
                    ["price", ">=", $collection['min_price']],
                    ["price", "<=", $collection['max_price']],
                ];

                $query->where($whereQuery);
            })
            ->withCount([
                "comments" => function ($query) {
                    $query->active = 1;
                }
            ])
            ->withSum("comments", "star")
            ->join("products", "banners_products.id_product", "products.id")
            ->orderBy("products.price", $collection['sort_type'] == 0 ? "asc" : "desc")
            ->skip($collection['offset'])
            ->take($collection['limit'])
            ->get();

        return $this->successResponse("Success", $banner);
    }
}
