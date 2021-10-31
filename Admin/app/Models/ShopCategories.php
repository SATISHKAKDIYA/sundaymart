<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ShopCategories extends Model
{
    protected $table = "shop_categories";
    protected $primaryKey = "id";

    public function language() {
        return $this->hasOne(ShopCategoriesLanguage::class, "id_shop_category", "id");
    }
}
