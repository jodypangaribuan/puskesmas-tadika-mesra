<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use App\Models\User;

class AdminSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Create a single admin account
        User::create([
            'name' => 'Administrator',
            'email' => 'admin@puskesmas.com',
            'password' => Hash::make('admin123'),
            'role' => 'admin',
            'nip' => '19800101001',
            'phone' => '08123456789',
            'position' => 'Kepala Puskesmas',
            'email_verified_at' => now(),
        ]);
    }
} 