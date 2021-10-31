<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Orders extends Model
{
    protected $table = "orders";
    protected $primaryKey = "id";

    protected $fillable = [
        'tax',
        'delivery_fee',
        'total_sum',
        'total_discount',
        'delivery_date',
        'processing_date',
        'ready_date',
        'delivered_date',
        'cancel_date',
        'delivery_time_id',
        'active',
        'type',
        'comment',
        'id_user',
        'order_status',
        'payment_status',
        'payment_method',
        'id_shop',
        'id_delivery_address'
    ];

    public function shop()
    {
        return $this->belongsTo(Shops::class, "id_shop", "id");
    }

    public function details()
    {
        return $this->hasMany(OrdersDetail::class, "id_order", "id");
    }

    public function address()
    {
        return $this->hasOne(Addresses::class, "id", "id_delivery_address");
    }

    public function timeUnit()
    {
        return $this->hasOne(TimeUnits::class, "id", "delivery_time_id");
    }

    public function deliveryBoy()
    {
        return $this->hasOne(Admin::class, "id", "id_delivery_boy");
    }
}
