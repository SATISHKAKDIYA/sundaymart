<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateAddressesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('addresses', function (Blueprint $table) {
            $table->increments('id');
            $table->mediumText('address');
            $table->decimal('latitude', $precision = 14, $scale = 4)->default('0.0000');
            $table->decimal('longtitude', $precision = 14, $scale = 4)->default('0.0000');
            $table->tinyInteger('default');
            $table->tinyInteger('active');
            $table->unsignedInteger('id_user');
            $table->timestamps();
            $table->foreign('id_user')->references('id')->on('clients')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('addresses');
    }
}
