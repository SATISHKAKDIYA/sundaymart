<?php

namespace App\Http\Requests\Admin;

use Illuminate\Contracts\Validation\Validator;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Http\Exceptions\HttpResponseException;

class AboutRequest extends FormRequest
{
    public function rules()
    {
        return [
            'about_content' => 'required',
            'id_shop' => 'required|numeric',
        ];
    }


    public function messages()
    {
        return [
            "id_shop.required" => "Id shop is required",
            "about_content.required" => "About content is required"
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
