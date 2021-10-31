<?php

namespace App\Repositories\Interfaces;

interface BannerInterface
{
    public function delete($id);

    public function createOrUpdate($collection = []);

    public function get($id_shop);

    public function getBannerForRest($id_shop, $id_lang);

    public function getBannerProductsForRest($collection = []);
}
