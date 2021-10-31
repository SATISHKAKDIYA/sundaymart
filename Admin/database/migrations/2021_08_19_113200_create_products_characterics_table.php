<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateProductsCharactericsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('products_characterics', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('id_product')->default(0);
            $table->tinyInteger('active');
            $table->foreign('id_product')->references('id')->on('products')->onDelete('cascade')->onUpdate('restrict');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('products_characterics');
    }
}
