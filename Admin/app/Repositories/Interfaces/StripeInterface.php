<?php

namespace App\Repositories\Interfaces;

interface StripeInterface
{
    public function createCustomer($params);

    public function setCardToken($params);

    public function shopBalanceCharge($params);
}
