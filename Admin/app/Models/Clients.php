<?php


namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Clients extends Model
{
    protected $table = "clients";
    protected $primaryKey = "id";

    protected $fillable = [
        'name',
        'surname',
        'phone',
        'email',
        'password',
        'social_id',
        'auth_type',
        'device_type',
        'token',
        'push_token',
        'active',
    ];
}
