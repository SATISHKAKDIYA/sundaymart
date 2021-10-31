<?php

namespace App\Http\Controllers\Mobile;

use App\Http\Controllers\Controller;
use App\Repositories\Interfaces\FaqInterface;
use Illuminate\Http\Request;

class FaqController extends Controller
{
    private $faqRepository;

    public function __construct(FaqInterface $faq)
    {
        $this->faqRepository = $faq;
    }

    public function faq(Request $request)
    {
       return $this->faqRepository->get($request->id_shop);
    }
}
