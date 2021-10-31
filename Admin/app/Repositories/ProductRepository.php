<?php

namespace App\Repositories;

use App\Models\Faq as Model;
use App\Models\Products;
use App\Models\ProductsComment;
use App\Repositories\Interfaces\ProductInterface;
use App\Traits\ApiResponse;

class ProductRepository extends CoreRepository implements ProductInterface
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
        try {

        } catch (\Exception $e) {
            return $this->errorResponse($e->getMessage());
        }
    }

    public function get($id_shop)
    {

    }

    public function saveProductComment($collection = [])
    {
        $comment = ProductsComment::updateOrCreate([
            'id_product' => $collection['id_product'],
            'id_user' => $collection['id_user'],
        ], [
            'comment_text' => $collection['comment'],
            'star' => $collection['star'],
            'id_user' => $collection['id_user'],
            'id_product' => $collection['id_product'],
            'active' => 1
        ]);

        if ($comment) {
            $product = Products::withCount([
                "comments" => function ($query) {
                    $query->active = 1;
                }
            ])
                ->withSum("comments", "star")
                ->where([
                    'id' => $collection['id_product'],
                ])->first();

            return $this->successResponse("success", $product);
        }

        return $this->errorResponse("error");
    }

    public function getProductExtrasForRest($id_product, $id_lang)
    {
        $data = Products::where("id", $id_product)
            ->with([
                "comments" => function ($query) {
                    $query->take(10)->skip(0);
                    $query->orderBy("star");
                },
                "comments.user",
                "description.language" => function ($query) use ($id_lang) {
                    $query->id_lang = $id_lang;
                },
                "extras" => function ($query) {
                    $query->active = 1;
                },
                "extras.extras" => function ($query) {
                    $query->active = 1;
                },
                "extras.language" => function ($query) use ($id_lang) {
                    $query->id_lang = $id_lang;
                },
                "extras.extras.language" => function ($query) use ($id_lang) {
                    $query->id_lang = $id_lang;
                },
            ])
            ->withCount([
                "comments" => function ($query) {
                    $query->active = 1;
                }
            ])
            ->first();

        return $this->successResponse("success", $data);
    }
}
