<?php

namespace App\Repositories;

use App\Models\Shops as Model;
use App\Models\ShopsCurriencies;
use App\Repositories\Interfaces\CurrencyInterface;
use App\Traits\ApiResponse;

class CurrencyRepository extends CoreRepository implements CurrencyInterface
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

    public function getAllActiveCurrenciesForRest($collection = [])
    {
        $currency = ShopsCurriencies::where([
            "id_shop" => $collection['id_shop']
        ])
            ->with([
                "currency.language" => function ($query) use ($collection) {
                    $query->id_lang = $collection['id_lang'];
                }
            ])
            ->get();

        return $this->successResponse("success", $currency);
    }
}
