<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateMessagesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('messages', function (Blueprint $table) {
            $table->id();
            $table->integer('user_id')->default(0);
            $table->integer('user_type')->default(0);
            $table->unsignedInteger('dialog_id')->default(0);
            $table->mediumText('text')->nullable();
            $table->tinyInteger('is_read')->default(0);
            $table->foreign('dialog_id')->references('id')->on('dialogs')->onDelete('cascade')->onUpdate('restrict');
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
        Schema::dropIfExists('messages');
    }
}
