<?php

namespace App\Repositories;

use App\Models\About as Model;
use App\Models\AboutLanguage;
use App\Models\Languages;
use App\Repositories\Interfaces\AboutInterface;
use App\Traits\ApiResponse;

class AboutRepository extends CoreRepository implements AboutInterface
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
                $about = Model::findOrFail($collection['id']);
            } else {
                $about = new Model();
            }

            $about->id_shop = $collection['id_shop'];
            if ($about->save()) {
                $id = $about->id;
                foreach ($collection['about_content'] as $key => $value) {
                    $language = Languages::getByShortName($key);

                    $about_language = null;

                    if ($collection['id'] > 0) {
                        $about_language = AboutLanguage::where([
                            "id_about" => $id,
                            "id_lang" => $language->id
                        ])->first();
                    }

                    if(!$about_language)
                        $about_language = new AboutLanguage();

                    $about_language->id_lang = $language->id;
                    $about_language->id_about = $id;
                    $about_language->content = $value;
                    $about_language->save();
                }

                return $this->successResponse("About context successfully saved", []);
            }

            return $this->errorResponse("error in saving about");
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
