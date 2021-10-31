<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;


class ExtrasGroupTypeDataSeeder extends Seeder
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
                'name' => 'Button with image',
            ],
            [
                'id' => 2,
                'name' => 'Button with color',
            ],
            [
                'id' => 3,
                'name' => 'Button with title',
            ],
        ];

        foreach ($data as $key => $value) {
            DB::table('product_extra_input_types')->insert([
                'id' => $value['id'],
                'name' => $value['name'],
                'active' => 1,
            ]);
        }
    }
}
