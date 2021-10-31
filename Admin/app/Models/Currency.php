<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Currency extends Model
{
    protected $table = "currency";
    protected $primaryKey = "id";

    public function language() {
        return $this->hasOne(CurrencyLanguage::class, "id_currency", "id");
    }
}
