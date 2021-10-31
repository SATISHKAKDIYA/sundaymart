<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;


class LanguageDataSeeder extends Seeder
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
                'name' => 'English',
                'short_name' => 'en',
                'image_url' => 'unnamed.png',
                'active' => 1,
                'default' => 1
            ],
            [
                'id' => 2,
                'name' => 'Russian',
                'short_name' => 'ru',
                'image_url' => 'logo.jpg',
                'active' => 1,
                'default' => NULL
            ],

        ];

        foreach ($data as $key => $value) {
            DB::table('language')->insert([
                'id' => $value['id'],
                'name' => $value['name'],
                'short_name' => $value['short_name'],
                'image_url' => $value['image_url'],
                'active' => $value['active'],
                'default' => $value['default'],
            ]);
        }
    }
}
