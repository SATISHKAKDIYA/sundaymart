<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateOrderPointsRuleLanguageTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('order_points_rule_language', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('id_lang')->default(0);
            $table->unsignedInteger('id_order_points_rule')->default(0);
            $table->mediumText('name')->nullable();
            $table->mediumText('description')->nullable();
            $table->foreign('id_lang')->references('id')->on('language')->onDelete('cascade')->onUpdate('restrict');
            $table->foreign('id_order_points_rule')->references('id')->on('order_points_rule')->onDelete('cascade')->onUpdate('restrict');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('order_points_rule_language');
    }
}
