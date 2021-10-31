<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class OrdersDetail extends Model {
    protected $table = "order_details";
    protected $primaryKey = "id";

    public $timestamps = false;

    protected $fillable = [
        'quantity',
        'discount',
        'price',
        'id_order',
        'id_product'
    ];

    public function product() {
        return $this->belongsTo(Products::class,"id_product", "id");
    }
}
