<?php

namespace App\Http\Controllers;

use App\Http\Requests\Admin\FaqRequest;
use App\Models\Languages;
use App\Repositories\Interfaces\FaqInterface;
use App\Traits\ApiResponse;
use App\Traits\DatatableResponse;
use Illuminate\Http\Request;
use App\Models\Faq;
use Illuminate\Support\Facades\Validator;

class FaqController extends Controller
{
    use DatatableResponse;
    use ApiResponse;

    private $faqRepository;

    public function __construct(FaqInterface $faq)
    {
        $this->faqRepository = $faq;
    }

    public function save(FaqRequest $request)
    {
        return $this->faqRepository->createOrUpdate($request->all());
    }

    public function datatable(Request $request)
    {
        $totalData = Faq::count();
        $totalFiltered = $totalData;

        $language = Languages::getDefaultLanguage();

        $datas = Faq::with([
            "language" => function ($query) use ($language) {
                $query->id_lang = $language->id;
            },
            "shop.language" => function ($query) use ($language) {
                $query->id_lang = $language->id;
            },
        ])
            ->take($request->length)
            ->skip($request->start)
            ->get();

        $responseData = [];

        foreach ($datas as $data) {
            $nestedData['id'] = $data['id'];
            $nestedData['question'] = $data['language']['question'];
            $nestedData['answer'] = $data['language']['answer'];
            $nestedData['shop'] = $data['shop']['language']['name'];
            $nestedData['active'] = $data['active'];
            $nestedData['options'] = [
                'delete' => 1,
                'edit' => 1
            ];

            $responseData[] = $nestedData;
        }

        return $this->responseJsonDatatable($totalData, $totalFiltered, $responseData);
    }

    public function delete(Request $request)
    {
        $id = $request->id;

        $faq = Faq::findOrFail($id);
        if ($faq) {
            $faq->delete();
        }

        return response()->json([
            'success' => 1,
            'msg' => "Successfully deleted"
        ]);
    }

    public function get(Request $request)
    {
        $v = Validator::make($request->all(), [
            'id' => 'required'
        ]);

        if ($v->fails()) {
            return response()->json([
                'error' => 1,
                'msg' => $v->errors()
            ]);
        }

        $id = $request->id;
        $id_lang = $request->id_lang;

        if ($id > 0) {

            $faq = Faq::select("faq.*", "faq_language.*")
                ->join('faq_language', 'faq_language.id_faq', '=', 'faq.id')
                ->where([
                    'faq_language.id_lang' => $id_lang,
                    'faq.id' => $id
                ])->first();

        }

        if (!empty($faq)) {
            return response()->json([
                'success' => 1,
                'msg' => "Success",
                'data' => $faq
            ]);
        }

        return response()->json([
            'success' => 0,
            'msg' => "No data available."
        ]);
    }
}
