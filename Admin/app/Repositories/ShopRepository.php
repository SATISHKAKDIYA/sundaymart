<?php

namespace App\Repositories;

use App\Models\Admin;
use App\Models\ShopCategories;
use App\Models\Shops;
use App\Models\Shops as Model;
use App\Models\TimeUnits;
use App\Repositories\Interfaces\ShopInterface;
use App\Traits\ApiResponse;

class ShopRepository extends CoreRepository implements ShopInterface
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

    public function getShopCategories($id_lang)
    {
        $categories = ShopCategories::with([
            "language" => function ($query) use ($id_lang) {
                $query->id_lang = $id_lang;
            }
        ])->where([
            'active' => 1,
        ])
            ->get();

        return $this->successResponse("success", $categories);
    }

    public function getShopUser($id_shop)
    {
        $user = Admin::where("id_shop", $id_shop)->first();

        if (!$user)
            $user = Admin::where("id_role", 1)->first();

        return $this->successResponse("success", $user);
    }

    public function getTimeUnitsForRest($id_shop)
    {
        $time_units = TimeUnits::where([
            'active' => 1,
            'id_shop' => $id_shop
        ])
            ->get();

        return $this->successResponse("success", $time_units);
    }

    public function getShopsForRest($collection = [])
    {
        $whereQuery = [
            'active' => 1
        ];
        if ($collection['id_shop_categories'] > 0)
            $whereQuery['id_shop_category'] = $collection['id_shop_categories'];

        $shops = Shops::with([
            'language' => function ($query) use ($collection) {
                $query->where([
                    'id_lang' => $collection['id_lang'],
                    ['name', '!=', null]
                ]);
                $query->orWhere([
                    ['name', '!=', null]
                ]);
            }
        ])->where($whereQuery)
            ->whereIn('delivery_type', [$collection['delivery_type'], 3])
            ->skip($collection['offset'])
            ->take($collection['limit'])
            ->get();

        return $this->successResponse("success", $shops);
    }
}
