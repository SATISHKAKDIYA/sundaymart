<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreatePrivacyLanguageTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('privacy_language', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('id_privacy')->default(0);
            $table->unsignedInteger('id_lang')->default(0);
            $table->mediumText('content')->nullable();
            $table->foreign('id_privacy')->references('id')->on('privacy')->onDelete('cascade')->onUpdate('restrict');
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
        Schema::dropIfExists('privacy_language');
    }
}
