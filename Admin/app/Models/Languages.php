<?php


namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Languages extends Model
{
    protected $table = "language";
    protected $primaryKey = "id";
    public $timestamps = false;

    protected $visible = ["id", "name", "short_name", "image_url", "default", "active", "mobileParams"];

    public static function getByShortName($short_name)
    {
        return static::where("short_name", $short_name)->first();
    }

    public static function getDefaultLanguage()
    {
        return static::where("default", 1)->first();
    }

    public function mobileParams() {
        return $this->hasMany(MobileParamsLanguage::class, "id_lang", "id");
    }
}
