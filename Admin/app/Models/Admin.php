<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Tymon\JWTAuth\Contracts\JWTSubject;
use Tymon\JWTAuth\Facades\JWTAuth;


class Admin extends Authenticatable implements JWTSubject
{
    use Notifiable;

    public function getJWTIdentifier()
    {
        return $this->getKey();
    }

    public function getJWTCustomClaims()
    {
        return [];
    }

    protected $table = "admins";
    protected $primaryKey = "id";

    public static function getUserShopId()
    {
        $token = JWTAuth::getToken();
        $user = JWTAuth::toUser($token);

        if ($user->id_role == 1) {
            return -1;
        }

        return $user->id_shop;
    }

    public static function getUserId()
    {
        $token = JWTAuth::getToken();
        $user = JWTAuth::toUser($token);
        return $user->id;
    }
}
