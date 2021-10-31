<?php


namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Products extends Model
{
    protected $table = "products";
    protected $primaryKey = "id";

    public function images()
    {
        return $this->hasMany(ProductsImages::class, 'id_product', 'id');
    }

    public function language()
    {
        return $this->hasOne(ProductsLanguage::class, 'id_product', 'id');
    }

    public function discount()
    {
        return $this->hasOne(DiscountProducts::class, 'id_product', 'id');
    }

    public function coupon()
    {
        return $this->hasOne(CouponProducts::class, 'id_product', 'id');
    }

    public function category()
    {
        return $this->belongsTo(Categories::class, 'id_category', 'id');
    }

    public function comments()
    {
        return $this->hasMany(ProductsComment::class, 'id_product', 'id');
    }

    public function units()
    {
        return $this->belongsTo(Units::class, 'id_unit', 'id');
    }

    public function brands() {
        return $this->belongsTo(Brands::class,"id_brand", "id");
    }

    public function description() {
        return $this->hasMany(ProductsCharacterics::class, "id_product", "id");
    }

    public function extras() {
        return $this->hasMany(ProductExtrasGroup::class, "id_product", "id");
    }
}
