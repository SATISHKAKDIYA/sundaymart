<?php

namespace App\Repositories\Interfaces;

interface FaqInterface
{
    public function delete($id);

    public function createOrUpdate($collection = []);

    public function get($id_shop);
}
