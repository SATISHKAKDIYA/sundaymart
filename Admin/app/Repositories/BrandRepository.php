<?php

namespace App\Repositories;

use App\Models\BrandCategories;
use App\Models\Brands;
use App\Models\Products;
use App\Models\Shops as Model;
use App\Repositories\Interfaces\BrandInterface;
use App\Traits\ApiResponse;

class BrandRepository extends CoreRepository implements BrandInterface
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

    public function get($id_brand)
    {
    }

    public function getBrandCategoriesForRest($id_shop, $id_lang)
    {
        $brand_categories = BrandCategories::with([
            "language" => function ($query) use ($id_lang) {
                $query->id_lang = $id_lang;
            },
        ])->whereHas("brands", function ($query) use ($id_shop) {
            $query->where("id_shop", $id_shop);
        })->get();

        return $this->successResponse("success", $brand_categories);
    }

    public function getBrandProductsForRest($collection = [])
    {
        $whereQuery = [
            "id_brand" => $collection['id_brand'],
            ["price", ">=", $collection['min_price']],
            ["price", "<=", $collection['max_price']],
        ];

        $products = Products::with([
            "images",
            "units.language" => function ($query) use ($collection) {
                $query->id_lang = $collection['id_lang'];
            },
            "discount.discount" => function ($query) {
                $query->active = 1;
            },
            "coupon",
            "language" => function ($query) use ($collection) {
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
            ->whereHas("language", function ($query) use ($collection) {
                if (strlen($collection['search']) >= 3) {
                    $query->where("name", "like", "%" . $collection['search'] . "%");
                }
            })
            ->where($whereQuery)
            ->orderBy("price", $collection['sort_type'] == 0 ? "asc" : "desc")
            ->skip($collection['offset'])
            ->take($collection['limit'])
            ->get();

        return $this->successResponse("success", $products);
    }

    public function getBrandsForRest($collection = [])
    {
        $brands = Brands::select("brands.id", "brands.name", "brands.image_url")
            ->where('brands.active', 1)
            ->where('brands.id_shop', $collection['id_shop']);
        if ($collection['id_brand_category'] > 0)
            $brands = $brands->where('brands.id_brand_category', $collection['id_brand_category']);

        if ($collection['limit'] > 0)
            $brands = $brands
                ->offset($collection['offset'])
                ->limit($collection['limit']);

        $brands = $brands->get();

        return $this->successResponse("success", $brands);
    }
}
