<?php

namespace App\Http\Requests\Rest;

use Illuminate\Contracts\Validation\Validator;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Http\Exceptions\HttpResponseException;

class BrandProductRestRequest extends FormRequest
{
    public function rules()
    {
        return [
            'id_brand' => 'required|numeric',
            'id_lang' => 'required|numeric'
        ];
    }


    public function messages()
    {
        return [
            "id_brand.required" => "Id brand is required",
            "id_lang.required" => "Id language category is required"
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
