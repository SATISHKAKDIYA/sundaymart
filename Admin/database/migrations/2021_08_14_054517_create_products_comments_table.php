<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateProductsCommentsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('products_comments', function (Blueprint $table) {
            $table->increments('id');
            $table->mediumText('comment_text')->nullable();
            $table->integer('star');
            $table->integer('active');
            $table->timestamps();
            $table->unsignedInteger('id_user');
            $table->unsignedInteger('id_product');
            $table->foreign('id_product')->references('id')->on('products')->onDelete('cascade');
            $table->foreign('id_user')->references('id')->on('clients')->onDelete('cascade');


        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('products_comments');
    }
}
