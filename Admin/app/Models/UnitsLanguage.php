<?php


namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class UnitsLanguage extends Model
{
    protected $table = "units_language";
    protected $primaryKey = "id";
    public $timestamps = false;

    protected $visible = ["name"];
}
