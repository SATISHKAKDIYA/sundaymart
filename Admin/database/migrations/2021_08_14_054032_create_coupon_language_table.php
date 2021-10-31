<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateCouponLanguageTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('coupon_language', function (Blueprint $table) {
            $table->increments('id');
            $table->mediumText('description')->nullable();
            $table->unsignedInteger('id_coupon')->nullable();
            $table->unsignedInteger('id_lang');

            $table->foreign('id_coupon')->references('id')->on('coupon')->onDelete('cascade');
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
        Schema::dropIfExists('coupon_language');
    }
}
