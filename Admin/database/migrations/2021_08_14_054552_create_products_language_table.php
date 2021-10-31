<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateProductsLanguageTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('products_language', function (Blueprint $table) {
            $table->increments('id');
            $table->string('name')->nullable();
            $table->mediumText('description')->nullable();
            $table->unsignedInteger('id_product');
            $table->unsignedInteger('id_lang');
            $table->foreign('id_lang')->references('id')->on('language')->onDelete('cascade');
            $table->foreign('id_product')->references('id')->on('products')->onDelete('cascade');



        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('products_language');
    }
}
