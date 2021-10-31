<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateOrderDetailExtraTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('order_details_extras', function (Blueprint $table) {
            $table->id();
            $table->timestamps();
            $table->unsignedInteger('id_order_detail')->default(0);
            $table->unsignedInteger('id_extras')->default(0);
            $table->double('price', 22, 2);
            $table->foreign('id_order_detail')->references('id')->on('order_details')->onDelete('cascade');
            $table->foreign('id_extras')->references('id')->on('product_extras')->onDelete('cascade');

        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('order_detail_extra');
    }
}
