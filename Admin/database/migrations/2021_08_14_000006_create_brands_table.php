<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateBrandsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('brands', function (Blueprint $table) {
            $table->increments('id');
            $table->string('name', 255)->nullable();
            $table->string('image_url', 255)->nullable();
            $table->integer('active');
            $table->timestamps();
            $table->unsignedInteger('id_shop');
            $table->unsignedInteger('id_brand_category');

            $table->foreign('id_shop')->references('id')->on('shops')->onDelete('cascade');
            $table->foreign('id_brand_category')->references('id')->on('brand_categories')->onDelete('cascade');

        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('brands');
    }
}
