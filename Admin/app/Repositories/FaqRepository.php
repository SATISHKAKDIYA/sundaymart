<?php

namespace App\Repositories;

use App\Models\Faq as Model;
use App\Models\FaqLanguage;
use App\Models\Languages;
use App\Repositories\Interfaces\FaqInterface;
use App\Traits\ApiResponse;

class FaqRepository extends CoreRepository implements FaqInterface
{
    use ApiResponse;

    public function __construct()
    {
        parent::__construct();
    }

    protected function getModelClass()
    {
        $this->model = Model::class;
    }

    public function delete($id)
    {

    }

    public function createOrUpdate($collection = [])
    {
        try {
            if ($collection['id'] > 0) {
                $faq = Model::findOrFail($collection['id']);
            } else {
                $faq = new Model();
            }

            $faq->id_shop = $collection['id_shop'];
            $faq->active = $collection['active'];
            if ($faq->save()) {
                $id = $faq->id;
                foreach ($collection['questions'] as $key => $value) {
                    $language = Languages::getByShortName($key);

                    $faq_language = null;

                    if ($collection['id'] > 0) {
                        $faq_language = FaqLanguage::where([
                            "id_faq" => $id,
                            "id_lang" => $language->id
                        ])->first();
                    }

                    if(!$faq_language)
                        $faq_language = new FaqLanguage();

                    $faq_language->id_lang = $language->id;
                    $faq_language->id_faq = $id;
                    $faq_language->question = $value;
                    $faq_language->answer = $collection['answers'][$key];
                    $faq_language->save();
                }

                return $this->successResponse("Faq successfully saved", []);
            }

            return $this->errorResponse("error in saving faq");
        } catch (\Exception $e) {
            return $this->errorResponse($e->getMessage());
        }
    }

    public function get($id_shop) {
        $data = Model::where("id_shop", $id_shop)->with([
            "languages",
            "languages.language",
        ])->first();

        return $this->successResponse("success", $data);
    }
}
