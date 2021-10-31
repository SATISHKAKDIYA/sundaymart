<?php


namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ProductsComment extends Model
{
    protected $table = "products_comments";
    protected $primaryKey = "id";

    protected $visible = ["comment_text", "star", "user", "created_at"];
    protected $fillable = ["id_product", "id_user", 'comment_text',
        'star',
        'active'];

    public function user()
    {
        return $this->belongsTo(Clients::class, "id_user", 'id');
    }
}
