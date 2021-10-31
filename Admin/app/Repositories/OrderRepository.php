<?php

namespace App\Repositories;

use App\Models\Addresses;
use App\Models\Faq as Model;
use App\Models\Orders;
use App\Models\OrdersDetail;
use App\Models\OrdersDetailExtras;
use App\Models\Shops;
use App\Repositories\Interfaces\OrderInterface;
use App\Traits\ApiResponse;

class OrderRepository extends CoreRepository implements OrderInterface
{
    use ApiResponse;

    public function __construct()
    {
        parent::__construct();
    }

    protected function getModelClass()
    {
        $this->model = Model::class;
    }

    public function delete($id)
    {

    }

    public function createOrUpdateForRest($collection = [])
    {
        try {
            $defaultAddress = Addresses::where([
                "id_user" => $collection['user'],
                "default" => 1
            ])->first();

            if ($defaultAddress) {
                $defaultAddress->default = 0;
                $defaultAddress->save();
            }

            $address = Addresses::updateOrCreate([
                "latitude" => round($collection['address']['lat'], 4),
                "longtitude" => round($collection['address']['lng'], 4),
                "id_user" => $collection['user'],
            ], [
                'latitude' => round($collection['address']['lat'], 4),
                'longtitude' => round($collection['address']['lng'], 4),
                'address' => $collection['address']['address'],
                'default' => 1,
                'active' => 1,
                'id_user' => $collection['user']
            ]);

            if ($address) {
                $id_address = $address->id;
                $shop = Shops::find($collection["shop"]);

                $order = Orders::create([
                    'tax' => $shop->tax,
                    'delivery_fee' => $shop->delivery_price,
                    'total_sum' => $collection['total'],
                    'total_discount' => $collection['discount'],
                    'delivery_date' => $collection['delivery_date'],
                    'delivery_time_id' => $collection['delivery_time_id'],
                    'active' => 1,
                    'type' => $collection['delivery_type'],
                    'comment' => $collection['comment'],
                    'id_user' => $collection['user'],
                    'order_status' => 1,
                    'payment_status' => $collection['payment_status'],
                    'payment_method' => $collection['payment_type'],
                    'id_shop' => $collection['shop'],
                    'id_delivery_address' => $id_address
                ]);

                if ($order) {
                    $id_order = $order->id;
                    foreach ($collection['products'] as $product) {
                        $orderDetail = OrdersDetail::create([
                            'quantity' => $product["count"],
                            'discount' => $product["discount"],
                            'price' => $product["price"],
                            'id_order' => $id_order,
                            'id_product' => $product["id"]
                        ]);

                        if ($orderDetail) {
                            $id_order_detail = $orderDetail->id;
                            if (count($product["extras"]) > 0)
                                foreach ($product["extras"] as $extras) {
                                    OrdersDetailExtras::create([
                                        'id_order_detail' => $id_order_detail,
                                        'id_extras' => $extras['id'],
                                        'price' => $extras['price']
                                    ]);
                                }
                        }
                    }

                    return $this->successResponse("success", []);
                }
            }

            return $this->errorResponse("error in saving faq");
        } catch (\Exception $e) {
            return $this->errorResponse($e->getMessage());
        }
    }

    public function get($id_shop)
    {
        $data = Model::where("id_shop", $id_shop)->with([
            "languages",
            "languages.language",
        ])->first();

        return $this->successResponse("success", $data);
    }

    public function changeOrderStatus($id_order, $status)
    {
        $order = Orders::findOrFail($id_order);
        if ($order) {
            $order->order_status = $status;
            $order->save();
        }

        return $this->successResponse("success", $order);
    }

    public function getOrderDetailByStatusForRest($collection = [])
    {
        $statuses = [$collection['status']];
        if ($collection['status'] == 1) $statuses = [1, 2, 3];

        $order = Orders::with([
            "shop.language" => function ($query) use ($collection) {
                $query->id_lang = $collection['id_lang'];
            },
            "details",
            "timeUnit",
            "address",
            "deliveryBoy",
            "details.product.language" => function ($query) use ($collection) {
                $query->id_lang = $collection['id_lang'];
            },
            "details.product.images"
        ])->where([
            "id_user" => $collection['id_user']
        ])
            ->whereIn("order_status", $statuses)
            ->skip($collection['offset'])
            ->take($collection['limit'])
            ->get();

        return $this->successResponse("success", $order);
    }

    public function getOrderCountByStatusAndClient($collection = [])
    {
        if (is_array($collection['status']))
            $order = Orders::where([
                "id_user" => $collection['id_user']
            ])->whereIn("order_status", $collection['status'])->count();
        else
            $order = Orders::where([
                "id_user" => $collection['id_user']
            ])->where("order_status", $collection['status'])->count();

        return $this->successResponse("success", $order);
    }
}
