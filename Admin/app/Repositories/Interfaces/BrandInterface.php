<?php

namespace App\Repositories\Interfaces;

interface BrandInterface
{
    public function delete($id);

    public function createOrUpdate($collection = []);

    public function get($id_shop);

    public function getBrandCategoriesForRest($id_shop, $id_lang);

    public function getBrandProductsForRest($collection = []);

    public function getBrandsForRest($collection = []);
}
