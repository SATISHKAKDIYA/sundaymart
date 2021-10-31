<?php


namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class BannersProducts extends Model
{
    protected $table = "banners_products";
    protected $primaryKey = "id";

    public $timestamps = false;

    public function product() {
        return $this->belongsTo(Products::class, "id_product", "id");
    }

    public function comments()
    {
        return $this->hasMany(ProductsComment::class, 'id_product', 'id_product');
    }
}
