<?php

namespace App\Repositories;

use App\Models\Coupon;
use App\Models\CouponProducts;
use App\Models\Shops as Model;
use App\Repositories\Interfaces\CouponInterface;
use App\Traits\ApiResponse;

class CouponRepository extends CoreRepository implements CouponInterface
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

    public function get($id_shop)
    {

    }

    public function createOrUpdate($collection = [])
    {
    }

    public function delete($id)
    {
    }

    public function getCouponProducts($collection = [])
    {
        $products = CouponProducts::with([
            "coupon" => function ($query) use ($collection) {
                $query->active = 1;
                $query->id_shop = $collection['id_shop'];
            },
            "product" => function ($query) {
                $query->active = 1;
            },
            "product.images",
            "product.units.language" => function ($query) use ($collection) {
                $query->id_lang = $collection['id_lang'];
            },
            "product.language" => function ($query) use ($collection) {
                $query->where([
                    'id_lang' => $collection['id_lang'],
                    ['name', '!=', null]
                ]);
                $query->orWhere([
                    ['name', '!=', null]
                ]);
            },
        ])
            ->withCount([
                "comments" => function ($query) {
                    $query->active = 1;
                }
            ])
            ->withSum("comments", "star")
            ->skip($collection['offset'])
            ->take($collection['limit'])
            ->get();

        return $this->successResponse("success", $products);
    }
}
