<?php

namespace App\Http\Controllers\Mobile;

use App\Http\Controllers\Controller;
use App\Http\Requests\Rest\CurrencyRestRequest;
use App\Repositories\Interfaces\CurrencyInterface;

class CurrencyController extends Controller
{
    private $currencyRepository;

    public function __construct(CurrencyInterface $currency)
    {
        $this->currencyRepository = $currency;
    }

    public function active(CurrencyRestRequest $request)
    {
        return $this->currencyRepository->getAllActiveCurrenciesForRest($request->all());
    }
}
