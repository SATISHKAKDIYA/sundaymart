<?php

namespace App\Repositories\Interfaces;

interface CurrencyInterface
{
    public function delete($id);

    public function createOrUpdate($collection = []);

    public function get($id_shop);

    public function getAllActiveCurrenciesForRest($collection = []);
}
