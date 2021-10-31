<?php

namespace App\Http\Controllers\Mobile;

use App\Http\Controllers\Controller;
use App\Http\Requests\Rest\CategoryProductRestRequest;
use App\Http\Requests\Rest\CategoryRestRequest;
use App\Repositories\Interfaces\CategoryInterface;


class CategoriesController extends Controller
{
    private $categoriesRepository;

    public function __construct(CategoryInterface $category)
    {
        $this->categoriesRepository = $category;
    }

    public function products(CategoryProductRestRequest $request)
    {
        return $this->categoriesRepository->getCategoryProductsForRest($request->all());
    }

    public function categories(CategoryRestRequest $request)
    {
        return $this->categoriesRepository->getCategoriesForRest($request->all());
    }
}
