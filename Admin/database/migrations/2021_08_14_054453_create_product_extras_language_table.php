<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateProductExtrasLanguageTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('product_extras_language', function (Blueprint $table) {
            $table->increments('id');
            $table->string('name')->nullable();
            $table->mediumText('description')->nullable();
            $table->unsignedInteger('id_extras');
            $table->unsignedInteger('id_lang');

            $table->foreign('id_lang')->references('id')->on('language');
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
        Schema::dropIfExists('product_extras_language');
    }
}
