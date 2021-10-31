<?php

namespace App\Repositories\Interfaces;

interface OrderInterface
{
    public function delete($id);

    public function createOrUpdateForRest($collection = []);

    public function get($id_shop);

    public function changeOrderStatus($id_order, $status);

    public function getOrderDetailByStatusForRest($collection = []);

    public function getOrderCountByStatusAndClient($collection = []);
}
