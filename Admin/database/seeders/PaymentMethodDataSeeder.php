<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;


class PaymentMethodDataSeeder extends Seeder
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
                'name' => 'Cash',
                'active' => 1,
            ],
            [
                'id' => 2,
                'name' => 'Card',
                'active' => 1,
            ],
            [
                'id' => 3,
                'name' => 'Terminal',
                'active' => 0,
            ],

        ];

        foreach ($data as $key => $value) {
            DB::table('payment_method')->insert([
                'id' => $value['id'],
                'name' => $value['name'],
                'active' => $value['active'],
                'created_at' => date('Y-m-d H:i:s'),
                'updated_at' => date('Y-m-d H:i:s'),

            ]);
        }
    }
}
