<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateShopPaymentTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('shop_payment', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('id_shop')->nullable();
            $table->unsignedInteger('id_payment')->nullable();
            $table->text('api_key')->nullable();
            $table->boolean('status')->default(1);
            $table->timestamps();

            $table->foreign('id_shop')->references('id')->on('shops')->onDelete('cascade');
            $table->foreign('id_payment')->references('id')->on('payments');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('shop_payment');
    }
}
