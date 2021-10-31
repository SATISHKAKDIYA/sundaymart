<?php

namespace App\Repositories\Interfaces;

interface NotificationInterface
{
    public function delete($id);

    public function createOrUpdate($collection = []);

    public function get($id_shop);

    public function getAllNotifications($collection = []);
}
