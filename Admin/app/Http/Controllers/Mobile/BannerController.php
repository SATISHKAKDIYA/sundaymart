<?php

namespace App\Http\Controllers\Mobile;

use App\Http\Controllers\Controller;
use App\Http\Requests\Rest\BannerRestRequest;
use App\Http\Requests\Rest\BannerProductsRestRequest;
use App\Repositories\Interfaces\BannerInterface;


class BannerController extends Controller
{
    private $bannerRepository;

    public function __construct(BannerInterface $banner)
    {
        $this->bannerRepository = $banner;
    }

    public function banners(BannerRestRequest $request)
    {
        return $this->bannerRepository->getBannerForRest($request->id_shop, $request->id_lang);
    }

    public function products(BannerProductsRestRequest $request)
    {
        return $this->bannerRepository->getBannerProductsForRest($request->all());
    }
}
