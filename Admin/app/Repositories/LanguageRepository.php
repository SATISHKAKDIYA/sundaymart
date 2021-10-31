<?php


namespace App\Repositories;

use App\Models\Faq as Model;
use App\Models\Languages;
use App\Models\MobileParams;
use App\Repositories\Interfaces\LanguageInterface;
use App\Traits\ApiResponse;

class LanguageRepository extends CoreRepository implements LanguageInterface
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

        } catch (\Exception $e) {
            return $this->errorResponse($e->getMessage());
        }
    }

    public function get($id_shop)
    {
    }

    public function getAllActiveLanguages() {
        $languages = Languages::where("active", 1)->get();

        return $this->successResponse("success", $languages);
    }

    public function getDictionary() {
        $languages = Languages::select("id", "short_name")
            ->where("active", 1)->get();

        $responceData = [];
        foreach ($languages as $data) {
            $messages = [];
            $id_lang = $data["id"];

            $datas = MobileParams::select("name", "default", "id")->with([
                "language" => function ($query) use ($id_lang) {
                    $query->where("id_lang", $id_lang);
                }
            ])->get();

            foreach ($datas as $mob) {
                $messages[$mob['name']] = $mob["language"] != null && strlen($mob['language']['name']) > 0 ? $mob['language']['name'] : $mob['default'];
            }

            $responceData[$data['short_name']] = $messages;
        }

        return $this->successResponse("success", $responceData);
    }
}
