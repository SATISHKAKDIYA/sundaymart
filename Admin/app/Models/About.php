<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class About extends Model
{
    protected $table = "about";
    protected $primaryKey = "id";
    public $timestamps = false;

    public function language() {
        return $this->hasOne(AboutLanguage::class, "id_about", "id");
    }

    public function languages() {
        return $this->hasMany(AboutLanguage::class, "id_about", "id");
    }
}
