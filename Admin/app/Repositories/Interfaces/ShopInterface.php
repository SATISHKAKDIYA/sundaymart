<?php

namespace App\Repositories\Interfaces;

interface ShopInterface
{
    public function getShopCategories($id_lang);

    public function getShopUser($id_shop);

    public function getTimeUnitsForRest($id_shop);

    public function getShopsForRest($collection = []);
}
