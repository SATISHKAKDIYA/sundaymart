<?php

namespace App\Repositories\Interfaces;

interface AboutInterface
{
    public function delete($id);

    public function createOrUpdate($collection = []);

    public function get($id_shop);
}
