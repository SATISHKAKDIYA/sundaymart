<?php

namespace App\Http\Controllers\Mobile;

use App\Http\Controllers\Controller;
use App\Repositories\Interfaces\LanguageInterface;


class LanguageController extends Controller
{
    private $languageRepository;

    public function __construct(LanguageInterface $language)
    {
        $this->languageRepository = $language;
    }

    public function active()
    {
        return $this->languageRepository->getAllActiveLanguages();
    }

    public function language()
    {
        return $this->languageRepository->getDictionary();
    }
}
