<?php


namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Addresses extends Model
{
    protected $table = "addresses";
    protected $primaryKey = "id";
    protected $fillable = [
        "latitude",
        "longtitude",
        "id_user",
        'address',
        'default',
        'active',];
}
