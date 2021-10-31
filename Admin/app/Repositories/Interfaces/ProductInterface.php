<?php

namespace App\Repositories\Interfaces;

interface ProductInterface
{
    public function delete($id);

    public function createOrUpdate($collection = []);

    public function get($id_shop);

    public function saveProductComment($collection = []);

    public function getProductExtrasForRest($id_product, $id_lang);
}
