<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreatePaymentLanguageTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('payment_language', function (Blueprint $table) {
            $table->increments('id');
            $table->mediumText('name')->nullable();
            $table->unsignedInteger('id_lang')->nullable();
            $table->unsignedInteger('id_payment')->nullable();

            $table->foreign('id_lang')->references('id')->on('language');
            $table->foreign('id_payment')->references('id')->on('payments')->onDelete('cascade');

        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('payment_language');
    }
}
