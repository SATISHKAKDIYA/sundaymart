<?php

namespace App\Repositories;

use App\Models\Clients;
use App\Models\Shops as Model;
use App\Repositories\Interfaces\ClientInterface;
use App\Repositories\Interfaces\ShopInterface;
use App\Traits\ApiResponse;
use Illuminate\Support\Facades\Hash;

class ClientRepository extends CoreRepository implements ClientInterface
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

    public function get($id_shop)
    {

    }

    public function createOrUpdate($collection = [])
    {
    }

    public function delete($id)
    {
    }

    public function loginForRest($collection = [])
    {
        if (isset($collection['phone']) && isset($collection['password'])) {
            $client = Clients::where('phone', '=', $collection['phone'])->first();

            if ($client === null) {
                return $this->errorResponse("Client does not exist in our system.");
            } else {
                if (Hash::check($collection['password'], $client->password)) {
                    $client->push_token = $collection['push_token'];
                    $client->save();

                    return $this->successResponse("success", $client);
                } else {
                    return $this->errorResponse("Password is wrong.");
                }
            }
        }

        if (isset($collection['social_id'])) {
            $client = Clients::where('social_id', '=', $collection['social_id'])->first();

            if ($client === null) {
                return $this->errorResponse("Client does not exist in our system.");
            } else {
                $client->push_token = $collection['push_token'];
                $client->save();

                return $this->successResponse("success", $client);
            }
        }

        return $this->errorResponse("Client does not exist in our system.");
    }

    public function updateUserForRest($collection = [])
    {
        if ($collection['id'] > 0)
            Clients::updateOrCreate(
                [
                    'id' => $collection['id']
                ],
                [
                    'name' => $collection['name'],
                    'surname' => $collection['surname'],
                    'phone' => $collection['phone'],
                    'email' => $collection['email'],
                    'gender' => $collection['gender'],
                    'image_url' => $collection['image_url'],
                    'password' => $collection['password'],
                ]);

        return $this->successResponse("success", []);
    }

    public function createUserForRest($collection = [])
    {
        if (isset($collection['phone'])) {
            if (Clients::where('phone', '=', $collection['phone'])->exists()) {
                return $this->errorResponse("Client already exist in our system.");
            }
        }

        if (isset($collection['social_id'])) {
            if (Clients::where('social_id', '=', $collection['social_id'])->exists()) {
                return $this->errorResponse("Client already exist in our system.");
            }
        }

        $token = bin2hex(openssl_random_pseudo_bytes(35));

        $client = Clients::create(
            [
                'name' => $collection['name'],
                'surname' => $collection['surname'],
                'phone' => $collection['phone'],
                'email' => $collection['email'],
                'password' => Hash::make($collection['password']),
                'social_id' => $collection['social_id'],
                'auth_type' => $collection['auth_type'],
                'device_type' => $collection['device_type'],
                'token' => $token,
                'push_token' => $collection['push_token'],
                'active' => 1,
            ]);

        return $this->successResponse("success", [
            'token' => $token,
            'data' => $client
        ]);
    }
}
