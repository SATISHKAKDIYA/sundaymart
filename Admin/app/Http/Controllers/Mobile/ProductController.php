<?php

namespace App\Http\Controllers\Mobile;

use App\Http\Controllers\Controller;
use App\Repositories\Interfaces\ProductInterface;
use Illuminate\Http\Request;


class ProductController extends Controller
{
    private $productRepository;

    public function __construct(ProductInterface $product)
    {
        $this->productRepository = $product;
    }

    public function comments(Request $request)
    {
        return $this->productRepository->saveProductComment($request->all());
    }

    public function extraData(Request $request)
    {
        return $this->productRepository->getProductExtrasForRest($request->id_product, $request->id_lang);
    }
}
