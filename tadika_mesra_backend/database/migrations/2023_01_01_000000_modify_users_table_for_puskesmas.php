<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class ModifyUsersTableForPuskesmas extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('role')->default('staff')->after('email');
            $table->string('nip')->nullable()->after('role');
            $table->string('phone')->nullable()->after('nip');
            $table->string('position')->nullable()->after('phone');
            $table->string('profile_photo')->nullable()->after('position');
            $table->timestamp('last_login_at')->nullable()->after('remember_token');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn([
                'role',
                'nip',
                'phone',
                'position',
                'profile_photo',
                'last_login_at',
            ]);
        });
    }
} 