<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class RoleDataSeeder extends Seeder
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
                'name' => 'Superadmin',
                'active' => 1,
            ],
            [
                'id' => 2,
                'name' => 'Manager',
                'active' => 1,
            ],
            [
                'id' => 3,
                'name' => 'Delivery boy',
                'active' => 1,
            ],
            
        ];

        foreach ($data as $key => $value) {
            DB::table('roles')->insert([
                'id' => $value['id'],
                'name' => $value['name'],
                'active' => $value['active'],
            ]);
        }
    }
}
