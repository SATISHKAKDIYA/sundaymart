<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateProductExtraGroupsLanguageTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('product_extra_groups_language', function (Blueprint $table) {
            $table->increments('id');
            $table->string('name')->nullable();
            $table->unsignedInteger('id_extra_group');
            $table->unsignedInteger('id_lang');

            $table->foreign('id_extra_group')->references('id')->on('product_extra_groups')->onDelete('cascade');
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
        Schema::dropIfExists('product_extra_groups_language');
    }
}
