<?php

namespace App\Http\Controllers\Mobile;

use App\Http\Controllers\Controller;
use App\Http\Requests\Rest\DiscountRestRequest;
use App\Repositories\Interfaces\AboutInterface;

class AboutController extends Controller
{
    private $aboutRepository;

    public function __construct(AboutInterface $about)
    {
        $this->aboutRepository = $about;
    }

    public function about(DiscountRestRequest $request)
    {
        return $this->aboutRepository->get($request->id_shop);
    }
}
