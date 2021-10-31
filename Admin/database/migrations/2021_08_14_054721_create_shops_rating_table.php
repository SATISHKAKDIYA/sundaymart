<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateShopsRatingTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('shops_rating', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('id_client')->default(0);
            $table->unsignedInteger('id_shop');
            $table->decimal('rating', 10, 2)->default(0.00);
            $table->timestamps();
            $table->foreign('id_client')->references('id')->on('clients')->onDelete('cascade');
            $table->foreign('id_shop')->references('id')->on('shops')->onDelete('cascade');


        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('shops_rating');
    }
}
