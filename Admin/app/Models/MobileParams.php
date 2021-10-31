<?php


namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class MobileParams extends Model
{
    protected $table = "mobile_params";
    protected $primaryKey = "id";
    public $timestamps = false;

    public function language() {
        return $this->hasOne(MobileParamsLanguage::class, "id_param", "id");
    }
}
