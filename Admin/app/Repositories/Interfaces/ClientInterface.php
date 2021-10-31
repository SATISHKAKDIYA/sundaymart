<?php

namespace App\Repositories\Interfaces;

interface ClientInterface
{
    public function delete($id);

    public function createOrUpdate($collection = []);

    public function get($id_shop);

    public function loginForRest($collection = []);

    public function updateUserForRest($collection = []);

    public function createUserForRest($collection = []);
}
