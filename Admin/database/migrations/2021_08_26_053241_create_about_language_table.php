<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateAboutLanguageTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('about_language', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('id_about')->default(0);
            $table->unsignedInteger('id_lang')->default(0);
            $table->mediumText('content')->nullable();
            $table->foreign('id_about')->references('id')->on('about')->onDelete('cascade')->onUpdate('restrict');
            $table->foreign('id_lang')->references('id')->on('language')->onDelete('cascade')->onUpdate('restrict');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('about_language');
    }
}
