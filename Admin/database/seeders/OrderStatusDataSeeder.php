<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class OrderStatusDataSeeder extends Seeder
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
                'name' => 'Processing',
                'active' => 1,
            ],
            [
                'id' => 2,
                'name' => 'Ready',
                'active' => 1,
            ],
            [
                'id' => 3,
                'name' => 'On a Way',
                'active' => 1,
            ],
            [
                'id' => 4,
                'name' => 'Delivered',
                'active' => 1,
            ],
            [
                'id' => 5,
                'name' => 'Canceled',
                'active' => 1,
            ],
        ];

        foreach ($data as $key => $value) {
            DB::table('order_status')->insert([
                'id' => $value['id'],
                'name' => $value['name'],
                'active' => $value['active'],
                'created_at' => date('Y-m-d H:i:s'),
                'updated_at' => date('Y-m-d H:i:s'),
            ]);
        }
    }
}
