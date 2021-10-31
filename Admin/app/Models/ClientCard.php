<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ClientCard extends Model
{
    use HasFactory;
    protected $guarded = [];

    public function saveClientCard($params){
        $this->create([
        'client_id' => $params[''],
        'card_id'  => $params[''],
        'payment_method'  => $params[''],
        'token'  => $params['card[id]'],
        'last4'  => $params['card[last4]'],
        'brand'  => $params['card[brand]'],
        'default'  => 0
        ]);
    }
}
