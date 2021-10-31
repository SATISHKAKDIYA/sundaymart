<?php

namespace App\Repositories;

use App\Models\ClientCard;
use App\Models\Clients;
use App\Models\ShopPayment;
use App\Repositories\Interfaces\StripeInterface;
use App\Models\Transaction as Model;
use Stripe\StripeClient;

class StripeRepository extends CoreRepository implements StripeInterface
{

    public function __construct()
    {
        parent::__construct();
    }

    protected function getModelClass()
    {
        $this->model = Model::class;
    }

    public function createCustomer($params)
    {
        // TODO: Implement createCustomer() method.
    }

    public function setCardToken($array)
    {
        $client = Clients::find($array['client_id']);
        if ($client){
            $shopPayment = ShopPayment::where('id_shop', $array['shop_id'])->where('id_payment', $array['payment_id'])->first();
            if ($shopPayment){
                $stripe = new StripeClient($shopPayment->api_key);
                try {
                    $response = $stripe->tokens->create([
                        'card' => [
                            'number' => $array['number'],
                            'exp_month' => $array['exp_month'],
                            'exp_year' => $array['exp_year'],
                            'cvc' => $array['cvc'],
                        ],
                    ]);
                    return response()->json($response);

                } catch (\Exception $exception) {
                    return response()->json($exception->getMessage());
                }
            } else {
                return response()->json([
                    'success' => 0,
                    'msg' => "Shop API_KEY not found!"
                ]);
            }
        } else {
            return response()->json([
                'success' => 0,
                'msg' => "Client not found!"
            ]);
        }
    }

    public function shopBalanceCharge($array)
    {
        $shopPayment = ShopPayment::where('id_shop', $array['shop_id'])->where('id_payment', $array['payment_id'])->first();
        if ($shopPayment) {
            $card = ClientCard::where('id', $array['card_id'])->first();
            $stripe = new StripeClient($shopPayment->api_key);
            try {
                $response = $stripe->charges->create([
                    'amount' => $array['amount'],
                    'currency' => $array['currency'],
                    'card' => $card->token,
                    'description' => $array['description'],
                ]);
                return response()->json($response);

            } catch (\Exception $exception) {
                return response()->json($exception->getMessage());
            }
        } else {
            return response()->json([
                'success' => 0,
                'msg' => "Shop API_KEY not found!"
            ]);
        }
    }

}
