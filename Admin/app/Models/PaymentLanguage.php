<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PaymentLanguage extends Model
{
    protected $table = "payment_language";
    protected $primaryKey = "id";

    public $timestamps = false;
}
