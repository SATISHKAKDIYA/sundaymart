<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateShopsCurrienciesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('shops_curriencies', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('id_shop')->default(0);
            $table->unsignedInteger('id_currency')->default(0);
            $table->tinyInteger('default')->default(0);
            $table->decimal('value', 10, 4)->default(0.0000);
            $table->timestamps();
            $table->foreign('id_currency')->references('id')->on('currency')->onDelete('cascade')->onUpdate('restrict');
            $table->foreign('id_shop')->references('id')->on('shops')->onDelete('cascade')->onUpdate('restrict');

        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('shops_curriencies');
    }
}
