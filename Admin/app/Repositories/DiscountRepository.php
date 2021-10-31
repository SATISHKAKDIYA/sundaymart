<?php

namespace App\Repositories;

use App\Models\DiscountProducts;
use App\Repositories\Interfaces\DiscountInterface;
use App\Models\DiscountProducts as Model;
use App\Traits\ApiResponse;

class DiscountRepository extends CoreRepository implements DiscountInterface
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

    public function getDiscountProducts($collection = [])
    {
        $products = DiscountProducts::with([
            "discount" => function ($query) use ($collection) {
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
