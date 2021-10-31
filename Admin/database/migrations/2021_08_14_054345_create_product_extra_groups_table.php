<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateProductExtraGroupsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('product_extra_groups', function (Blueprint $table) {
            $table->increments('id');
            $table->integer('id_product')->default(0);
            $table->integer('active');
            $table->unsignedInteger('type');
            $table->timestamps();
            $table->foreign('type')->references('id')->on('product_extra_input_types');

        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('product_extra_groups');
    }
}
