<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateShopsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('shops', function (Blueprint $table) {
            $table->increments('id');
            $table->string('logo_url')->nullable();
            $table->string('backimage_url')->nullable();
            $table->integer('delivery_type');
            $table->double('delivery_price', 22, 0);
            $table->integer('delivery_range');
            $table->double('tax', 22, 0);
            $table->double('admin_percentage', 22, 0);
            $table->double('latitude', 22, 0);
            $table->double('longtitude', 22, 0);
            $table->string('phone')->nullable();
            $table->string('mobile')->nullable();
            $table->tinyInteger('show_type');
            $table->tinyInteger('is_closed');
            $table->tinyInteger('active');
            $table->time('open_hour');
            $table->time('close_hour');
            $table->integer('id_shop_category');
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
        Schema::dropIfExists('shops');
    }
}
