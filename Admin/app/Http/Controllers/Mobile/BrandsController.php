<?php

namespace App\Http\Controllers\Mobile;

use App\Http\Controllers\Controller;
use App\Http\Requests\Rest\BrandProductRestRequest;
use App\Http\Requests\Rest\BrandRestRequest;
use App\Http\Requests\Rest\CouponRestRequest;
use App\Repositories\Interfaces\BrandInterface;


class BrandsController extends Controller
{
    private $brandRepository;

    public function __construct(BrandInterface $brands)
    {
        $this->brandRepository = $brands;
    }

    public function get(BrandRestRequest $request)
    {
        return $this->brandRepository->getBrandsForRest($request->all());
    }


    public function products(BrandProductRestRequest $request)
    {
        return $this->brandRepository->getBrandProductsForRest($request->all());
    }

    public function categories(CouponRestRequest $request)
    {
        return $this->brandRepository->getBrandCategoriesForRest($request->id_shop, $request->id_lang);
    }
}
