<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DiscountProducts extends Model
{
    protected $table = "discount_products";
    protected $primaryKey = "id";

    public $timestamps = false;

    public function discount() {
        return $this->belongsTo(Discount::class, 'id_discount', 'id');
    }

    public function product() {
        return $this->belongsTo(Products::class, "id_product", "id");
    }

    public function comments()
    {
        return $this->hasMany(ProductsComment::class, 'id_product', 'id_product');
    }
}
