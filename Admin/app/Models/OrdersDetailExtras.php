<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class OrdersDetailExtras extends Model {
    protected $table = "order_details_extras";
    protected $primaryKey = "id";

    public $timestamps = false;

    protected $fillable = [
        'id_order_detail',
        'id_extras',
        'price'
    ];
}
