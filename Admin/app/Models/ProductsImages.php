<?php


namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ProductsImages extends Model
{
    protected $table = "products_images";
    protected $primaryKey = "id";
    protected $visible = ["image_url"];

    public $timestamps = false;
}
