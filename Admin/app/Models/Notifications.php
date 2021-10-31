<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Notifications extends Model
{
    protected $table = "notifications";
    protected $primaryKey = "id";

    public function shop() {
        return $this->belongsTo(Shops::class, "id_shop", "id");
    }
}
