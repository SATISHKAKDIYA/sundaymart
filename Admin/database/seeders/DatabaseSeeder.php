<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        // \App\Models\User::factory(10)->create();
        $this->call(RoleDataSeeder::class);
        $this->call(AdminDataSeeder::class);
        $this->call(PermissionDataSeeder::class);
        $this->call(LanguageDataSeeder::class);
        $this->call(MobileParamsDataSeeder::class);
        $this->call(OrderStatusDataSeeder::class);
        $this->call(PaymentStatusDataSeeder::class);
        $this->call(PaymentMethodDataSeeder::class);




    }
}
