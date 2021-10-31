<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateProductsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('products', function (Blueprint $table) {
            $table->increments('id');
            $table->integer('quantity');
            $table->integer('pack_quantity');
            $table->double('weight', 22, 0);
            $table->double('price', 22, 0);
            $table->double('discount_price', 22, 0);
            $table->tinyInteger('show_type');
            $table->integer('active');
            $table->timestamps();
            $table->unsignedInteger('id_unit')->nullable();
            $table->unsignedInteger('id_category');
            $table->unsignedInteger('id_shop')->nullable();
            $table->unsignedInteger('id_brand')->nullable();
            $table->foreign('id_unit')->references('id')->on('units')->onDelete('cascade');
            $table->foreign('id_brand')->references('id')->on('brands')->onDelete('cascade');
            $table->foreign('id_shop')->references('id')->on('shops')->onDelete('cascade');
            $table->foreign('id_category')->references('id')->on('categories')->onDelete('cascade');



        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('products');
    }
}
