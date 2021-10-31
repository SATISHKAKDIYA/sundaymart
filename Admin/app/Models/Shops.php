<?php


namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Shops extends Model
{
    protected $table = "shops";
    protected $primaryKey = "id";

    public function about() {
        return $this->hasOne(About::class, "id_shop", "id");
    }

    public function language() {
        return $this->hasOne(ShopsLanguage::class, "id_shop", "id");
    }
}
