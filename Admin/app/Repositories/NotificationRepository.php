<?php


namespace App\Repositories;

use App\Models\Faq as Model;
use App\Models\Notifications;
use App\Repositories\Interfaces\NotificationInterface;
use App\Traits\ApiResponse;

class NotificationRepository extends CoreRepository implements NotificationInterface
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

    public function createOrUpdate($collection = [])
    {
        try {

        } catch (\Exception $e) {
            return $this->errorResponse($e->getMessage());
        }
    }

    public function get($id_shop)
    {
    }

    public function getAllNotifications($collection = []) {
        $notifications = Notifications::with([
            "shop.language" => function($query) use($collection) {
                $query->id_lang = $collection['id_lang'];
            }
        ])->where([
            'id_shop' => $collection['id_shop'],
            'active' => 1,
            ["send_time", "<=", date("Y-m-d H:i:s", strtotime($collection['now']))],
            ["send_time", ">=", date("Y-m-d H:i:s", strtotime($collection['date']))]
        ])->get();

        return $this->successResponse("success", $notifications);
    }
}
