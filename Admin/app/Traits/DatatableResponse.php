<?php
namespace App\Traits;

trait DatatableResponse {
    public function responseJsonDatatable($totalData, $filteredData, $data) {
        return response()->json([
            "total" => intval($totalData),
            "filtered" => intval($filteredData),
            "data" => $data
        ]);
    }
}
