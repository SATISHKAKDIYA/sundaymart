<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateProductsCharactericsLanguageTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('products_characterics_language', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('id_product_characteristic')->default(0);
            $table->unsignedInteger('id_lang')->default(0);
            $table->string('key', 250)->nullable();
            $table->mediumText('value')->nullable();

            $table->foreign('id_lang')->references('id')->on('language')->onDelete('cascade');
            $table->foreign('id_product_characteristic')->references('id')->on('products_characterics')->onDelete('cascade');

        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('products_characterics_language');
    }
}
