<?php

namespace App\Repositories\Interfaces;

interface DiscountInterface
{
    public function getDiscountProducts($collection = []);
}
