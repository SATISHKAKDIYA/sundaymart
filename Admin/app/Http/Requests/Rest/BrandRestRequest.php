<?php

namespace App\Http\Requests\Rest;

use Illuminate\Contracts\Validation\Validator;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Http\Exceptions\HttpResponseException;

class BrandRestRequest extends FormRequest
{
    public function rules()
    {
        return [
            'id_shop' => 'required|numeric',
            'id_brand_category' => 'required|numeric'
        ];
    }


    public function messages()
    {
        return [
            "id_shop.required" => "Id shop is required",
            "id_brand_category.required" => "Id brand category is required"
        ];
    }

    public function failedValidation(Validator $validator)
    {
        $errors = $validator->errors();

        $response = response()->json([
            'success' => 0,
            'msg' => $errors->messages(),
        ], 422);

        throw new HttpResponseException($response);
    }
}
