<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateOrderDetailsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('order_details', function (Blueprint $table) {
            $table->increments('id');
            $table->integer('quantity');
            $table->double('discount', 22, 2)->default(0);
            $table->double('price', 22, 2);
            $table->double('coupon_amount', 22, 2)->nullable();
            $table->tinyInteger('is_replaced')->default(0);
            $table->tinyInteger('is_replacement_product')->default(0);
            $table->unsignedInteger('id_order');
            $table->unsignedInteger('id_replace_product')->nullable();
            $table->unsignedInteger('id_product');
            $table->unsignedInteger('id_coupon')->nullable();

            $table->foreign('id_product')->references('id')->on('products')->onDelete('cascade');
            $table->foreign('id_replace_product')->references('id')->on('products')->onDelete('cascade');
            $table->foreign('id_order')->references('id')->on('orders')->onDelete('cascade');
            $table->foreign('id_coupon')->references('id')->on('coupon')->onDelete('cascade');


        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('order_details');
    }
}
