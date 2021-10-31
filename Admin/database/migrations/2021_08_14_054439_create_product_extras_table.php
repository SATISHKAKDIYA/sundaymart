<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateProductExtrasTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('product_extras', function (Blueprint $table) {
            $table->increments('id');
            $table->double('price', 22, 0);
            $table->integer('quantity');
            $table->string('image_url')->nullable();
            $table->string('background_color')->nullable();
            $table->integer('active');
            $table->unsignedInteger('id_extra_group');
            $table->timestamps();
            $table->foreign('id_extra_group')->references('id')->on('product_extra_groups')->onDelete('cascade');

        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('product_extras');
    }
}
