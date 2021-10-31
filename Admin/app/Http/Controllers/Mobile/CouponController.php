<?php

namespace App\Http\Controllers\Mobile;

use App\Http\Controllers\Controller;
use App\Http\Requests\Rest\CouponRestRequest;
use App\Repositories\Interfaces\CouponInterface;

class CouponController extends Controller
{
    private $couponRepository;

    public function __construct(CouponInterface $coupon)
    {
        $this->couponRepository = $coupon;
    }

    public function coupon(CouponRestRequest $request)
    {
        return $this->couponRepository->getCouponProducts($request->all());
    }
}
