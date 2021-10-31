<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Coupon extends Model
{
    protected $table = "coupon";
    protected $primaryKey = "id";

    protected $visible = ["name", "discount_type", "discount", "usage_time", "valid_until"];
}
