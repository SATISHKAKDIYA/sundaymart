<?php


namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Units extends Model
{
    protected $table = "units";
    protected $primaryKey = "id";
    public $timestamps = false;

    protected $visible = [
        "language"
    ];

    public function language() {
        return $this->hasOne(UnitsLanguage::class, "id_unit", "id");
    }
}
