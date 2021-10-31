<?php

namespace App\Repositories\Interfaces;

interface CategoryInterface
{
    public function delete($id);

    public function createOrUpdate($collection = []);

    public function get($id_shop);

    public function getCategoryProductsForRest($collection = []);

    public function getCategoriesForRest($collection = []);
}
