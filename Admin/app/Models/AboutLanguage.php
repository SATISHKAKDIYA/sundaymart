<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AboutLanguage extends Model
{
    protected $table = "about_language";
    protected $primaryKey = "id";
    public $timestamps = false;

    public function language() {
        return $this->belongsTo(Languages::class, "id_lang", "id");
    }
}
