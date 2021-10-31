<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Banners extends Model
{
    protected $table = "banners";
    protected $primaryKey = "id";

    public function language()
    {
        return $this->hasOne(BannersLanguage::class, "id_banner", "id");
    }

    public function products()
    {
        return $this->hasMany(BannersProducts::class, "id_banner", "id");
    }
}
