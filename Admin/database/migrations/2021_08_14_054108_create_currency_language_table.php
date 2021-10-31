<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateCurrencyLanguageTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('currency_language', function (Blueprint $table) {
            $table->increments('id');
            $table->string('name', 50)->nullable();
            $table->unsignedInteger('id_lang')->default(0);
            $table->unsignedInteger('id_currency')->default(0);

            $table->foreign('id_currency')->references('id')->on('currency')->onDelete('cascade')->onUpdate('restrict');
            $table->foreign('id_lang')->references('id')->on('language')->onDelete('restrict')->onUpdate('restrict');

        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('currency_language');
    }
}
