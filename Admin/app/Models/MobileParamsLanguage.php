<?php


namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class MobileParamsLanguage extends Model
{
    protected $table = "mobile_params_lang";
    protected $primaryKey = "id";
    public $timestamps = false;

    public function language() {
        return $this->belongsTo(Languages::class, "id_lang", "id");
    }
}
