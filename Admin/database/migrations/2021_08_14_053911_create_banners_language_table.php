<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateBannersLanguageTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('banners_language', function (Blueprint $table) {
            $table->increments('id');
            $table->string('title', 255)->nullable()->default(null);
            $table->string('sub_title', 255)->nullable()->default(null);
            $table->mediumText('description')->nullable();
            $table->string('button_text', 255)->nullable()->default(null);
            $table->unsignedInteger('id_banner');
            $table->unsignedInteger('id_lang');

            $table->foreign('id_banner')->references('id')->on('banners')->onDelete('cascade');
            $table->foreign('id_lang')->references('id')->on('language');

        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('banners_language');
    }
}
