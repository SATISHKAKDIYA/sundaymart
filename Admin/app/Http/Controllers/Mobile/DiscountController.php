<?php

namespace App\Http\Controllers\Mobile;

use App\Http\Controllers\Controller;
use App\Http\Requests\Rest\DiscountRestRequest;
use App\Models\DiscountProducts;
use App\Repositories\Interfaces\DiscountInterface;

class DiscountController extends Controller
{
    private $discountRepository;

    public function __construct(DiscountInterface $discount)
    {
        $this->discountRepository = $discount;
    }

    public function discount(DiscountRestRequest $request)
    {
        return $this->discountRepository->getDiscountProducts($request->all());
    }
}
