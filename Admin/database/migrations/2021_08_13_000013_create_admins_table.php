<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateAdminsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('admins', function (Blueprint $table) {
            $table->increments('id');
            $table->string('name', 255);
            $table->string('surname', 255);
            $table->string('image_url', 255)->nullable();
            $table->string('email', 255);
            $table->string('phone', 255)->nullable();
            $table->string('password', 255);
            $table->tinyInteger('active');
            $table->integer('offline')->nullable();
            $table->unsignedInteger('id_shop')->nullable();
            $table->unsignedInteger('id_role');
            $table->timestamps();

            $table->foreign('id_shop')->references('id')->on('shops')->onDelete('cascade');
            $table->foreign('id_role')->references('id')->on('roles')->onDelete('cascade');

        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('admins');
    }
}
