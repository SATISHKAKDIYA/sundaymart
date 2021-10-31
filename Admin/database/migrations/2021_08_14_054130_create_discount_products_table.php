<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateDiscountProductsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('discount_products', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('id_product')->nullable()->default(0);
            $table->unsignedInteger('id_discount')->nullable()->default(0);

            $table->foreign('id_discount')->references('id')->on('discount')->onDelete('cascade')->onUpdate('restrict');
            $table->foreign('id_product')->references('id')->on('products')->onDelete('cascade')->onUpdate('restrict');

        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('discount_products');
    }
}
