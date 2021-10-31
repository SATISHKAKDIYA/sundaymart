<?php

namespace App\Http\Controllers\Mobile;

use App\Http\Controllers\Controller;
use App\Repositories\Interfaces\OrderInterface;
use Illuminate\Http\Request;


class OrderController extends Controller
{
    private $orderRepository;

    public function __construct(OrderInterface $order)
    {
        $this->orderRepository = $order;
    }

    public function save(Request $request)
    {
        return $this->orderRepository->createOrUpdateForRest($request->all());
    }

    public function getNewOrderCount(Request $request)
    {
        return $this->orderRepository->getOrderCountByStatusAndClient([
            'status' => [1,2,3],
            'id_user' => $request->id_user
        ]);
    }

    public function allOrderByStatus(Request $request)
    {
        return $this->orderRepository->getOrderDetailByStatusForRest($request->all());
    }


    public function orderCancel(Request $request) {
        return $this->orderRepository->changeOrderStatus($request->id, 5);
    }
}
