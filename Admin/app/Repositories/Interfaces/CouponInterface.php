<?php

namespace App\Repositories\Interfaces;

interface CouponInterface
{
    public function delete($id);

    public function createOrUpdate($collection = []);

    public function get($id_shop);

    public function getCouponProducts($collection = []);
}
