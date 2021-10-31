<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateDiscountTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('discount', function (Blueprint $table) {
            $table->increments('id');
            $table->tinyInteger('is_count_down')->default(0);
            $table->tinyInteger('discount_type')->default(0);
            $table->decimal('discount_amount', 10, 4)->default(0.0000);
            $table->dateTime('start_time')->nullable();
            $table->dateTime('end_time')->nullable();
            $table->tinyInteger('active');
            $table->unsignedInteger('id_shop');
            $table->foreign('id_shop')->references('id')->on('shops')->onDelete('cascade');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('discount');
    }
}
