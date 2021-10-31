<?php
namespace App\Traits;

trait ApiResponse {
    public function responseJson($message, $statusCode, $data, $isSuccess = true) {
        if($isSuccess)
            return response()->json([
                "message" => $message,
                "data" => $data,
                "success" => true,
                "code" => $statusCode
            ], $statusCode);

        return response()->json([
            "message" => $message,
            "success" => false,
            "code" => $statusCode
        ], $statusCode);
    }

    public function successResponse($message, $data) {
        return $this->responseJson($message, 200, $data);
    }

    public function errorResponse($message) {
        return $this->responseJson($message, 200, null, false);
    }
}
