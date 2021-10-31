<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB;

class AdminDataSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $data = [
            [
                'id' => 1,
                'name' => 'Admin55',
                'surname' => 'Admin',
                'email' => 'admin@gmail.com',
                'password' => Hash::make('admin1234'),
                'active' => 1,
                'id_role' => 1,

            ],
            [
                'id' => 2,
                'name' => 'Manager',
                'surname' => 'Manager',
                'email' => 'manager@gmail.com',
                'password' => Hash::make('manager1234'),
                'active' => 1,
                'id_role' => 2,

            ],

        ];

        foreach ($data as $key => $value) {
            DB::table('admins')->insert([
                'id' => $value['id'],
                'name' => $value['name'],
                'surname' => $value['surname'],
                'email' => $value['email'],
                'password' => $value['password'],
                'active' => $value['active'],
                'id_role' => $value['id_role'],
                'created_at' => date('Y-m-d H:i:s'),
                'updated_at' => date('Y-m-d H:i:s'),

            ]);
        }
    }
}
