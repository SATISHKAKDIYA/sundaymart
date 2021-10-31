<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateNotificationsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('notifications', function (Blueprint $table) {
            $table->increments('id');
            $table->string('title', 500)->nullable();
            $table->longText('description')->nullable();
            $table->tinyInteger('has_image')->default(0);
            $table->string('image_url', 250)->nullable();
            $table->tinyInteger('active')->default(0);
            $table->tinyInteger('is_sent');
            $table->dateTime('send_time');
            $table->timestamps();

            $table->unsignedInteger('id_shop');
            $table->unsignedInteger('id_user');
            $table->foreign('id_user')->references('id')->on('clients')->onDelete('cascade');
            $table->foreign('id_shop')->references('id')->on('shops')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('notifications');
    }
}
