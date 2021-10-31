<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ProductExtras extends Model
{
    protected $table = "product_extras";
    protected $primaryKey = "id";

    public function language() {
        return $this->hasOne(ProductExtrasLanguage::class, "id_extras", "id");
    }
}
