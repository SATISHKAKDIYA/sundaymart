<?php

namespace App\Http\Controllers\Payment;

use App\Http\Controllers\Controller;
use App\Models\ClientCard;
use App\Models\Transaction;
use App\Repositories\Interfaces\StripeInterface;
use Carbon\Carbon;
use Illuminate\Http\Request;

class StripeController extends Controller
{
    private $stripeRepository;

    public function __construct(StripeInterface $stripeRepository)
    {
        $this->stripeRepository = $stripeRepository;
    }

    public function setCardToken(Request $request)
    {
        $cardInfo= $this->stripeRepository->setCardToken($request->all());

        $params = [
            'card_id' => $cardInfo->original->card['id'] ?? null,
            'token' => $cardInfo->original->id,
            'payment_method' => 'stripe',
            'last4'  => $cardInfo->original->card['last4'] ?? null,
            'brand'  => $cardInfo->original->card['brand'] ?? null,
            'default'  => 1
        ];

        $result = ClientCard::updateOrCreate(['client_id' => $request->client_id],$params);

        return response()->json($result);
    }

    public function shopBalanceCharge(Request $request){
        $result = $this->stripeRepository->shopBalanceCharge($request->all());
        $result = $result->original;
        if (isset($result->status) && $result->status == 'succeeded'){
            $transaction = Transaction::create([
                'shop_id' => $request->shop_id,
                'client_id' => $request->client_id,
                'order_id' => $request->order_id,
                'payment_type' => 'stripe',
                'payment_trans_id' => $result->id,
                'amount' => $result->amount,
                'currency' => $result->currency,
                'perform_time' => Carbon::parse($result->created)->timestamp($result->created),
                'status' => $result->status,
                'status_description' => $result->description
            ]);

            return response()->json(['status' => 1, 'data' => $transaction]);
        } else{
            return response()->json(['status' => 0, 'message' => $result]);
        }

    }
}
