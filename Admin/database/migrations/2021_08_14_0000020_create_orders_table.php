<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateOrdersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {

        Schema::create('orders', function (Blueprint $table) {
            // $table->engine = 'InnoDB';
            $table->increments('id');
            $table->double('tax', 22, 2);
            $table->double('delivery_fee', 22, 2);
            $table->double('total_sum', 22, 2);
            $table->double('total_discount', 22, 2);
            $table->integer('delivery_mark')->nullable();
            $table->date('delivery_date');
            $table->dateTime('processing_date');
            $table->dateTime('ready_date');
            $table->dateTime('delivered_date');
            $table->dateTime('cancel_date');
            $table->integer('delivery_time_id')->default(0);
            $table->mediumText('comment')->nullable();
            $table->mediumText('checklist')->nullable();
            $table->tinyInteger('active');
            $table->tinyInteger('type');
            $table->timestamps();
            $table->unsignedInteger('id_user');
            $table->unsignedInteger('id_delivery_boy')->nullable();
            $table->unsignedInteger('order_status');
            $table->unsignedInteger('payment_status');
            $table->unsignedInteger('payment_method');
            $table->unsignedInteger('id_review')->nullable()->unique('REL_fe1a7dd16f1ecb55b516f1753f');
            $table->unsignedInteger('id_delivery_address')->nullable();
            $table->unsignedInteger('id_shop')->nullable();

            $table->foreign('id_user')->references('id')->on('clients')->onDelete('cascade');
            $table->foreign('order_status')->references('id')->on('order_status');
            $table->foreign('payment_status')->references('id')->on('payment_status');
            $table->foreign('id_delivery_address')->references('id')->on('addresses')->onDelete('cascade');
            $table->foreign('id_delivery_boy')->references('id')->on('admins')->onDelete('cascade');
            $table->foreign('payment_method')->references('id')->on('payment_method');
            $table->foreign('id_shop')->references('id')->on('shops')->onDelete('cascade');
            // $table->foreign('id_review')->references('id')->on('order_comments')->onDelete('SET NULL');


        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('orders');
    }
}
