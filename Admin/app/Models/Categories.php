<?php


namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Categories extends Model
{
    protected $table = "categories";
    protected $primaryKey = "id";

    public function products() {
        return $this->hasMany(Products::class, 'id_category','id');
    }

    public function language() {
        return $this->hasOne(CategoriesLanguage::class, 'id_category', 'id');
    }

    public function subcategories() {
        return $this->hasMany(Categories::class, 'parent');
    }

    public function parent() {
        return $this->belongsTo(Categories::class, 'parent', 'id');
    }
}
