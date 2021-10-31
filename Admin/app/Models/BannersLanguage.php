<?php


namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class BannersLanguage extends Model
{
    protected $table = "banners_language";
    protected $primaryKey = "id";

    public $timestamps = false;

    //protected $visible = ["title", "sub_title", "description", "button_text", "language"];

    public function language() {
        $this->hasOne(Languages::class, "id_lang", "id");
    }
}
