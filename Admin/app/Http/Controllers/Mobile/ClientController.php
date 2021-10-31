<?php

namespace App\Http\Controllers\Mobile;

use App\Http\Controllers\Controller;
use App\Repositories\Interfaces\ClientInterface;
use Illuminate\Http\Request;

class ClientController extends Controller
{
    private $clientRepository;

    public function __construct(ClientInterface $client)
    {
        $this->clientRepository = $client;
    }

    public function login(Request $request)
    {
        return $this->clientRepository->loginForRest($request->all());
    }

    public function update(Request $request)
    {
        return $this->clientRepository->updateUserForRest($request->all());
    }

    public function signup(Request $request)
    {
        return $this->clientRepository->createUserForRest($request->all());
    }
}
