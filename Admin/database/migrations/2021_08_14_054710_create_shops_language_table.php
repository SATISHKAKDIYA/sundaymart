<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateShopsLanguageTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('shops_language', function (Blueprint $table) {
            $table->increments('id');
            $table->string('name')->nullable();
            $table->mediumText('description')->nullable();
            $table->mediumText('info')->nullable();
            $table->string('address')->nullable();
            $table->unsignedInteger('id_lang');
            $table->unsignedInteger('id_shop');
            $table->foreign('id_lang')->references('id')->on('language')->onDelete('cascade');
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
        Schema::dropIfExists('shops_language');
    }
}
