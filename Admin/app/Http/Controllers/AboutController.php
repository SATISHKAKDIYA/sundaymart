<?php

namespace App\Http\Controllers;

use App\Http\Requests\Admin\AboutRequest;
use App\Models\Languages;
use App\Models\Shops;
use App\Repositories\Interfaces\AboutInterface;
use App\Traits\ApiResponse;
use App\Traits\DatatableResponse;
use Illuminate\Http\Request;

class AboutController extends Controller
{
    use DatatableResponse;
    use ApiResponse;

    private $aboutRepository;

    public function __construct(AboutInterface $about)
    {
        $this->aboutRepository = $about;
    }

    public function save(AboutRequest $request)
    {
        return $this->aboutRepository->createOrUpdate($request->all());
    }

    public function datatable(Request $request)
    {
        $totalData = Shops::where("active", 1)->count();
        $filteredData = $totalData;

        $language = Languages::getDefaultLanguage();

        $datas = Shops::where("active", 1)->with([
            "language",
            "about",
            "about.language" => function ($query) use ($language) {
                $query->id_lang = $language->id;
            }
        ])
            ->take($request->length)
            ->skip($request->start)
            ->get();

        $responseData = array();
        foreach ($datas as $data) {
            $nestedData['id_shop'] = $data['id'];
            $nestedData['shop'] = $data['language']['name'];
            $nestedData['context'] = $data['about'] == null ? "" : $data['about']['language']['content'];
            $nestedData['options'] = [
                'edit' => 1
            ];

            $responseData[] = $nestedData;
        }

        return $this->responseJsonDatatable($totalData, $filteredData, $responseData);
    }

    public function get(Request $request)
    {
        return $this->aboutRepository->get($request->id_shop);
    }
}
