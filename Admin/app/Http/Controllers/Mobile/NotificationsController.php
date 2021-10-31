<?php

namespace App\Http\Controllers\Mobile;

use App\Http\Controllers\Controller;
use App\Repositories\Interfaces\NotificationInterface;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\Notifications;


class NotificationsController extends Controller
{
    private $notificationRepository;

    public function __construct(NotificationInterface $notification)
    {
        $this->notificationRepository = $notification;
    }

    public function notifications(Request $request)
    {
        return $this->notificationRepository->getAllNotifications($request->all());
    }
}
