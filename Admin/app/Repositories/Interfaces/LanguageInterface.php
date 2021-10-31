<?php

namespace App\Repositories\Interfaces;

interface LanguageInterface
{
    public function delete($id);

    public function createOrUpdate($collection = []);

    public function get($id_shop);

    public function getAllActiveLanguages();

    public function getDictionary();
}
