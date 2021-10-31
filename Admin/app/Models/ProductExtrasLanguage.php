<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ProductExtrasLanguage extends Model {
    protected $table = "product_extras_language";
    protected $primaryKey = "id";

    public $timestamps = false;

    public function language() {
        return $this->hasOne(Languages::class, "id_class", "id");
    }
}
