<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateBannersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('banners', function (Blueprint $table) {
            $table->increments('id');
            $table->string('image_url', 255);
            $table->string('title_color', 255);
            $table->string('button_color', 255);
            $table->string('indicator_color', 255);
            $table->string('background_color', 255);
            $table->string('position', 255);
            $table->integer('active');
            $table->unsignedInteger('id_shop');
            $table->timestamps();

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
        Schema::dropIfExists('banners');
    }
}
