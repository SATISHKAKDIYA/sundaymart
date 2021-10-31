<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class OrderStatusHistory extends Model
{
    protected $table = "order_status_history";
    protected $primaryKey = "id";
    public $timestamps = false;
}
