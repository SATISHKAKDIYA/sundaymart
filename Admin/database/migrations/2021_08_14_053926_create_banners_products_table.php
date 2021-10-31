<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateBannersProductsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('banners_products', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('id_banner')->default(null);
            $table->unsignedInteger('id_product')->default(null);

            $table->foreign('id_banner')->references('id')->on('banners')->onDelete('cascade');
            $table->foreign('id_product')->references('id')->on('products');

        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('banners_products');
    }
}
