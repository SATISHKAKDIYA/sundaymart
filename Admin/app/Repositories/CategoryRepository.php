<?php

namespace App\Repositories;

use App\Models\Categories;
use App\Models\Products;
use App\Models\Shops as Model;
use App\Repositories\Interfaces\CategoryInterface;
use App\Traits\ApiResponse;

class CategoryRepository extends CoreRepository implements CategoryInterface
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

    public function getCategoryProductsForRest($collection = [])
    {
        $whereQuery = [
            "active" => 1,
            ["price", ">=", $collection['min_price']],
            ["price", "<=", $collection['max_price']],
        ];

        if ($collection['type'] != 0 && $collection['type'] != 3)
            $whereQuery['show_type'] = $collection['type'] + 1;

        $products = Products::with(["images",
            "coupon",
            "units.language",
            "discount.discount" => function ($query) {
                $query->active = 1;
            },
            "language" => function ($query) use ($collection) {
                $query->where([
                    'id_lang' => $collection['id_lang'],
                    ['name', '!=', null]
                ]);
                $query->orWhere([
                    ['name', '!=', null]
                ]);
            }])
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
            ->where(function ($query) use ($collection) {
                $query->orWhereHas(
                    "category", function ($query) use ($collection) {
                    $query->where("id", $collection['id_category']);
                });
                $query->orWhereHas(
                    "category.parent", function ($query) use ($collection) {
                    $query->where("id", $collection['id_category']);
                });
            })
            ->where($whereQuery);

        if (strlen($collection['brands']) > 0) {
            $products = $products->whereIn("id_brand", explode(",", $collection['brands']));
        }

        $products = $products
            ->skip($collection['offset'])
            ->take($collection['limit'])
            ->orderBy("price", $collection['sort_type'] == 0 ? "asc" : "desc")
            ->get();

        return $this->successResponse("success", $products);
    }

    public function getCategoriesForRest($collection = []) {
        $categories = Categories::where([
            "id_shop" => $collection['id_shop'],
            "parent" => $collection['id_category'],
            "active" => 1
        ]);

        if ($collection['id_category'] == -1)
            $categories = $categories->has("subcategories.products");
        else
            $categories = $categories->has("products");

        $categories = $categories->with([
            "language" => function ($query) use ($collection) {
                $query->where([
                    'id_lang' => $collection['id_lang'],
                    ['name', '!=', null]
                ]);
                $query->orWhere([
                    ['name', '!=', null]
                ]);
            }
        ]);
        if ($collection['limit'] > 0) {
            $categories = $categories->skip($collection['offset'])
                ->take($collection['limit']);
        }
        $categories = $categories->get();

        return $this->successResponse("success", $categories);
    }
}
