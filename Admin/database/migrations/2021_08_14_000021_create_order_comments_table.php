<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateOrderCommentsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('order_comments', function (Blueprint $table) {
            $table->increments('id');
            $table->mediumText('comment_text')->nullable();
            $table->integer('active');
            $table->timestamps();
            $table->unsignedInteger('id_user');
            $table->unsignedInteger('id_order')->unique();

            $table->foreign('id_user')->references('id')->on('clients')->onDelete('cascade');
            $table->foreign('id_order')->references('id')->on('orders')->onDelete('cascade');

        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('order_comments');
    }
}
