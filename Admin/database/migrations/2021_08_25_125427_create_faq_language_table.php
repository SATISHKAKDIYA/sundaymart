<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateFaqLanguageTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('faq_language', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('id_faq')->default(0);
            $table->unsignedInteger('id_lang')->default(0);
            $table->mediumText('question')->nullable();
            $table->mediumText('answer')->nullable();
            $table->foreign('id_faq')->references('id')->on('faq')->onDelete('cascade')->onUpdate('restrict');
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
        Schema::dropIfExists('faq_language');
    }
}
