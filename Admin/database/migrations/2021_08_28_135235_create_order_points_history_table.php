<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateOrderPointsHistoryTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('order_points_history', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('id_order_points')->default(0);
            $table->unsignedInteger('id_order')->default(0);
            $table->integer('point')->default(0);
            $table->integer('id_client')->default(0);
            $table->foreign('id_order_points')->references('id')->on('order_points')->onDelete('cascade')->onUpdate('restrict');
            $table->foreign('id_order')->references('id')->on('orders')->onDelete('cascade')->onUpdate('restrict');

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('order_points_history');
    }
}
