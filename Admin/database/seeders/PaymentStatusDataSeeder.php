<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;


class PaymentStatusDataSeeder extends Seeder
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
                'name' => 'Paid',
                'active' => 1,
            ],
            [
                'id' => 2,
                'name' => 'Not paid',
                'active' => 1,
            ],
        ];

        foreach ($data as $key => $value) {
            DB::table('payment_status')->insert([
                'id' => $value['id'],
                'name' => $value['name'],
                'active' => $value['active'],
                'created_at' => date('Y-m-d H:i:s'),
                'updated_at' => date('Y-m-d H:i:s'),

            ]);
        }
    }
}
