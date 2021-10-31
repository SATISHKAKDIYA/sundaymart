<?php

namespace App\Http\Requests\Admin;

use Illuminate\Contracts\Validation\Validator;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Http\Exceptions\HttpResponseException;

class FaqRequest extends FormRequest
{
    public function rules()
    {
        return [
            'active' => 'required',
            'id_shop' => 'required|numeric',
            'answers' => 'required',
            'questions' => 'required',
        ];
    }


    public function messages()
    {
        return [
            "id_shop.required" => "Id shop is required",
            "active.required" => "active is required",
            "answers.required" => "answers is required",
            "questions.required" => "questions is required",
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
