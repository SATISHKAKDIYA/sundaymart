<?php


namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Brands extends Model
{
    protected $table = "brands";
    protected $primaryKey = "id";

    public function category() {
        return $this->belongsTo(BrandCategories::class, "id_brand_catgeory", "id");
    }
}
