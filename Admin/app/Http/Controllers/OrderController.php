<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Clients;
use App\Models\Languages;
use App\Models\Orders;
use App\Models\OrdersComment;
use App\Models\OrdersDetail;
use App\Models\OrdersStatus;
use App\Models\Products;
use App\Models\Admin;

use App\Models\ShopsLanguage;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;

class OrderController extends Controller
{
    use ApiResponse;

    private $push_token = "AAAA5_EU5F8:APA91bHHXoSXt4cToBeCDNKPnKlxdqRA9dhLC33KQ8rQtXVYt51JFmS9_7wATcNX08cvG3DEbxn8DtAaT09iQFYizKLzktyVkmbpGBs9TRfFJ2k77RVfNfTyjU93Iuzbxa15mXzz5nYv";

    public function save(Request $request)
    {
        $id = $request->id;
        $tax = $request->tax;
        $delivery_fee = $request->delivery_fee;
        $total_sum = $request->total_sum;
        $total_discount = $request->total_discount;
        $delivery_time_id = $request->delivery_time_id;
        $delivery_date = $request->delivery_date;
        $comment = $request->comment;
        $type = $request->type;
        $id_user = $request->id_user;
        $id_delivery_address = $request->id_delivery_address;
        $id_shop = $request->id_shop;
        $order_status = $request->order_status;
        $payment_status = $request->payment_status;
        $payment_method = $request->payment_method;
        $product_details = $request->product_details;
        $delivery_boy_comment = $request->delivery_boy_comment;
        $delivery_boy = $request->delivery_boy;

        if ($id > 0)
            $order = Orders::findOrFail($id);
        else
            $order = new Orders();

        $order->tax = $tax;
        $order->delivery_fee = $delivery_fee;
        $order->total_sum = $total_sum;
        $order->total_discount = $total_discount;
        $order->delivery_date = date("y-m-d", strtotime($delivery_date));
        $order->delivery_time_id = $delivery_time_id;
        $order->comment = $delivery_boy_comment;
        $order->active = 1;
        $order->type = $type;
        $order->id_user = $id_user;
        $order->id_delivery_boy = $delivery_boy;
        $order->order_status = $order_status;
        if ($order_status == 2)
            $order->processing_date = date("Y-m-d H:i:s");
        if ($order_status == 3)
            $order->ready_date = date("Y-m-d H:i:s");
        if ($order_status == 4)
            $order->delivered_date = date("Y-m-d H:i:s");
        if ($order_status == 4)
            $order->cancel_date = date("Y-m-d H:i:s");

        $order->payment_status = $payment_status;
        $order->payment_method = $payment_method;
        $order->id_delivery_address = $id_delivery_address;
        $order->id_shop = $id_shop;
        if ($id > 0)
            $order->updated_at = date("Y-m-d H:i:s");
        else
            $order->created_at = date("Y-m-d H:i:s");
        if ($order->save()) {
            $user = Clients::find($id_user);

            $message = "";
            if ($order_status == 1)
                $message = $user->name . ", Your order accepted";
            else if ($order_status == 2)
                $message = $user->name . ", Your order ready to delivery";
            else if ($order_status == 3)
                $message = $user->name . ", Your order is in a way";
            else if ($order_status == 4)
                $message = $user->name . ", Your order delivered";

            if ($user)
                $this->sendNotification($message, $user->push_token);

            $order_id = $order->id;

            if ($comment && strlen($comment) > 1) {
                if ($id > 0) {
                    $order_review = OrdersComment::where("id_order", $id)->first();
                    if (!$order_review)
                        $order_review = new OrdersComment();
                } else
                    $order_review = new OrdersComment();

                $order_review->comment_text = $comment;
                $order_review->active = 1;
                $order_review->id_user = $id_user;
                $order_review->id_order = $order_id;
                if ($id > 0)
                    $order_review->updated_at = date("Y-m-d H:i:s");
                else
                    $order_review->created_at = date("Y-m-d H:i:s");

                if ($order_review->save()) {
                    $id_order_review = $order_review->id;

                    $order->id_review = $id_order_review;
                    $order->save();
                }

            }

            OrdersDetail::where("id_order", $order_id)->delete();

            if (count($product_details) > 0)
                foreach ($product_details as $product) {
                    $order_detail = new OrdersDetail();
                    $order_detail->quantity = $product['quantity'];
                    $order_detail->discount = $product['discount'];
                    $order_detail->price = $product['price'];
                    //$order_detail->is_replaced = ;
                    //$order_detail->is_replacement_product = ;
                    $order_detail->id_order = $order_id;
                    //$order_detail->id_replace_product = ;
                    $order_detail->id_product = $product['id'];
                    if ($order_detail->save()) {
                        $productModel = Products::findOrFail($product['id']);
                        if ($productModel) {
                            $productModel->quantity -= $product['quantity'];
                            $productModel->save();
                        }
                    }
                }

            return response()->json([
                'success' => 1,
                'msg' => "Successfully saved"
            ]);
        }

        return response()->json([
            'success' => 0,
            'msg' => "Error in saving language"
        ]);
    }

    public function statusDatatable(Request $request)
    {
        $totalData = OrdersStatus::count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');

        if (empty($request->input('search'))) {
            $datas = OrdersStatus::offset($start)
                ->limit($limit)
                ->get();
        } else {
            $search = $request->input('search');

            $datas = OrdersStatus::where('name', 'LIKE', "%{$search}%")
                ->where('id', 'LIKE', "%{$search}%")
                ->offset($start)
                ->limit($limit)
                ->get();

            $totalFiltered = OrdersStatus::where('id', 'LIKE', "%{$search}%")
                ->where('name', 'LIKE', "%{$search}%")
                ->count();
        }

        $responseData = array();
        if (!empty($datas)) {
            foreach ($datas as $data) {
                $nestedData['id'] = $data->id;
                $nestedData['name'] = $data->name;
                $nestedData['active'] = $data->active;
                $responseData[] = $nestedData;

            }
        }

        $json_data = array(
            "total" => intval($totalData),
            "filtered" => intval($totalFiltered),
            "data" => $responseData
        );

        return response()->json($json_data);
    }

    public function activeStatus()
    {
        $paymentStatus = OrdersStatus::where([
            "active" => 1
        ])->get();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => $paymentStatus
        ]);
    }

    public function datatable(Request $request)
    {
        $totalData = Orders::count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');

        $defaultLanguage = Languages::where("default", 1)->first();

        $shop_id = Admin::getUserShopId();

        if (empty($request->input('search'))) {
            $datas = Orders::select("orders.*", "clients.name", "clients.surname", "order_status.name as order_status_name",
                "payment_status.name as payment_status_name", "payment_method.name as payment_method_name", "time_units.name as time_units_name")
                ->join('clients', 'clients.id', '=', 'orders.id_user')
                ->join('order_status', 'order_status.id', '=', 'orders.order_status')
                ->join('payment_status', 'payment_status.id', '=', 'orders.payment_status')
                ->join('payment_method', 'payment_method.id', '=', 'orders.payment_method')
                ->join('time_units', 'time_units.id', '=', 'orders.delivery_time_id');

            if ($shop_id != -1) {
                $datas = $datas->where('orders.id_shop', $shop_id);
            }

            $datas = $datas
                ->orderBy("id", "desc")
                ->offset($start)
                ->limit($limit)
                ->get();
        } else {
            $search = $request->input('search');

            $datas = Orders::select("orders.*", "clients.name", "clients.surname",
                "order_status.name as order_status_name", "payment_status.name as payment_status_name",
                "payment_method.name as payment_method_name", "time_units.name as time_units_name")
                ->join('clients', 'clients.id', '=', 'orders.id_user')
                ->join('order_status', 'order_status.id', '=', 'orders.order_status')
                ->join('payment_status', 'payment_status.id', '=', 'orders.payment_status')
                ->join('payment_method', 'payment_method.id', '=', 'orders.payment_method')
                ->join('time_units', 'time_units.id', '=', 'orders.delivery_time_id')
                ->where('name', 'LIKE', "%{$search}%")
                ->where('id', 'LIKE', "%{$search}%");

            if ($shop_id != -1) {
                $datas = $datas->where('orders.id_shop', $shop_id);
            }

            $datas = $datas
                ->orderBy("id", "desc")
                ->offset($start)
                ->limit($limit)
                ->get();

            $totalFiltered = Orders::select("orders.*", "clients.name", "clients.surname",
                "order_status.name as order_status_name", "payment_status.name as payment_status_name",
                "payment_method.name as payment_method_name", "time_units.name as time_units_name")
                ->join('clients', 'clients.id', '=', 'orders.id_user')
                ->join('order_status', 'order_status.id', '=', 'orders.order_status')
                ->join('payment_status', 'payment_status.id', '=', 'orders.payment_status')
                ->join('payment_method', 'payment_method.id', '=', 'orders.payment_method')
                ->join('time_units', 'time_units.id', '=', 'orders.delivery_time_id')
                ->where('id', 'LIKE', "%{$search}%")
                ->where('name', 'LIKE', "%{$search}%");

            if ($shop_id != -1) {
                $datas = $datas->where('orders.id_shop', $shop_id);
            }

            $datas = $datas
                ->count();
        }

        $responseData = array();
        if (!empty($datas)) {
            foreach ($datas as $data) {
                $shop = null;
                if ($data['id_shop'] != null)
                    $shop = ShopsLanguage::where([
                        'id_lang' => $defaultLanguage->id,
                        'id_shop' => $data['id_shop']
                    ])->first();

                $nestedData['id'] = $data->id;
                $nestedData['amount'] = $data->total_sum;
                $nestedData['order_status'] = $data->order_status_name;
                $nestedData['order_status_id'] = $data->order_status;
                $nestedData['payment_status'] = $data->payment_status_name;
                $nestedData['payment_status_id'] = $data->payment_status;
                $nestedData['payment_method'] = $data->payment_method_name;
                $nestedData['payment_method_id'] = $data->payment_method;
                $nestedData['delivery_date'] = $data->delivery_date . " " . $data->time_units_name;
                $nestedData['order_date'] = date("Y-m-d H:i:s", strtotime($data->created_at));
                $nestedData['user'] = $data->name . " " . $data->surname;
                $nestedData['shop'] = $data['id_shop'] != null && $shop ? $shop->name : "-";
                $nestedData['active'] = $data->active;
                $nestedData['options'] = [
                    'delete' => 1,
                    'edit' => 1
                ];
                $responseData[] = $nestedData;

            }
        }

        $json_data = array(
            "total" => intval($totalData),
            "filtered" => intval($totalFiltered),
            "data" => $responseData,
        );

        return response()->json($json_data);
    }

    public function delete(Request $request)
    {
        $id = $request->id;

        $order = Orders::find($id);
        if ($order) {
            $order->delete();
        }

        return response()->json([
            'success' => 1,
            'msg' => "Successfully deleted"
        ]);
    }

    public function get(Request $request)
    {
        $id = $request->id;

        $defaultLanguage = Languages::where("default", 1)->first();

        $order = Orders::findOrFail($id);
        $order_detail = OrdersDetail::select("order_details.*", "products.quantity as product_quantity", "products_language.name")->where("id_order", $id)
            ->join('products', 'products.id', '=', 'order_details.id_product')
            ->join('products_language', 'products_language.id_product', '=', 'order_details.id_product')
            ->where("products_language.id_lang", $defaultLanguage->id)
            ->get();
        $order_comment = OrdersComment::where("id_order", $id)->first();

        return response()->json([
            'success' => 1,
            'msg' => "Success",
            'data' => [
                'order' => $order,
                'order_detail' => $order_detail,
                'order_comment' => $order_comment
            ]
        ]);
    }

    public function commentsDatatable(Request $request)
    {
        $totalData = OrdersComment::count();

        $totalFiltered = $totalData;

        $limit = $request->input('length');
        $start = $request->input('start');

        if (empty($request->input('search'))) {
            $datas = OrdersComment::select('order_comments.*', 'clients.name', 'clients.surname')
                ->join('clients', 'clients.id', '=', 'order_comments.id_user')
                ->offset($start)
                ->limit($limit)
                ->get();
        } else {
            $search = $request->input('search');

            $datas = OrdersComment::select('order_comments.*', 'clients.name', 'clients.surname')
                ->join('clients', 'clients.id', '=', 'order_comments.id_user')
                ->where('comment_text', 'LIKE', "%{$search}%")
                ->where('id', 'LIKE', "%{$search}%")
                ->offset($start)
                ->limit($limit)
                ->get();

            $totalFiltered = OrdersComment::select('order_comments.*', 'clients.name', 'clients.surname')
                ->join('clients', 'clients.id', '=', 'order_comments.id_user')
                ->where('id', 'LIKE', "%{$search}%")
                ->where('comment_text', 'LIKE', "%{$search}%")
                ->count();
        }

        $responseData = array();
        if (!empty($datas)) {
            foreach ($datas as $data) {
                $nestedData['id'] = $data->id;
                $nestedData['client'] = $data->name . " " . $data->surname;
                $nestedData['text'] = $data->comment_text;
                $nestedData['order'] = $data->id_order;
                $nestedData['active'] = $data->active;
                $nestedData['options'] = [
                    'delete' => 1,
                ];
                $responseData[] = $nestedData;

            }
        }

        $json_data = array(
            "total" => intval($totalData),
            "filtered" => intval($totalFiltered),
            "data" => $responseData
        );

        return response()->json($json_data);
    }

    public function sendNotification($message, $id)
    {
        $url = 'https://fcm.googleapis.com/fcm/send';

        $fields = array(
            'to' => $id,
            "notification" => [
                "body" => $message,
                "title" => "Githubit.com",
                //"icon" => "ic_launcher"
            ],
        );
        $fields = json_encode($fields);

        $headers = array(
            'Authorization: key=' . $this->push_token,
            'Content-Type: application/json'
        );

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $fields);

        $result = curl_exec($ch);
        curl_close($ch);
    }

    public function getActiveClients()
    {
        $count = Orders::groupBy("id_user")->count();

        return $this->successResponse("success", $count);
    }

    public function getTotalOrdersCount()
    {
        $count = Orders::count();

        return $this->successResponse("success", $count);
    }

    public function getOrdersStaticByStatus()
    {
        $canceled = [];
        $delivered = [];

        for ($i = 9; $i >= 0; $i--) {
            $date = date('Y-m-d', strtotime("-" . $i . " days"));

            $canceledCount = Orders::where([
                "order_status" => 5,
                ["created_at", ">=", $date . " 00:00:00"],
                ["created_at", "<=", $date . " 23:59:59"]
            ])->count();
            $deliveredCount = Orders::where([
                "order_status" => 4,
                ["created_at", ">=", $date . " 00:00:00"],
                ["created_at", "<=", $date . " 23:59:59"]
            ])->count();

            $canceled[] = ["time" => date("m-d", strtotime($date)), "value" => $canceledCount, "type" => 'Canceled'];
            $delivered[] = ["time" => date("m-d", strtotime($date)), "count" => $deliveredCount, "name" => 'Delivered'];
        }

        return $this->successResponse("success", [
            $canceled,
            $delivered
        ]);
    }

    public function getShopsSalesInfo()
    {
        $defaultLanguage = Languages::where("default", 1)->first();

        $data = [];
        $ordersData = Orders::groupBy("id_shop")->with(
            [
                "shop.language" => function ($query) use($defaultLanguage) {
                    $query->id_lang = $defaultLanguage->id;
                }
            ]
        )->selectRaw('*, sum(total_sum) as totalSum')->get();

        foreach ($ordersData as $order) {
            $data[] = [
                "shop" => $order['shop']['language']['name'],
                "value" => $order['totalSum']
            ];
        }

        return $this->successResponse("success", $data);
    }
}
