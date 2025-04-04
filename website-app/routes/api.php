<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\PasienApiController;
use App\Http\Controllers\Api\AuthApiController;
use App\Http\Controllers\Api\JadwalDokterApiController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

// Auth routes for mobile app
Route::post('/register', [AuthApiController::class, 'register']);
Route::post('/login', [AuthApiController::class, 'login']);

// Protected routes that require authentication
Route::middleware('auth:sanctum')->group(function () {
    // User profile
    Route::get('/profile', [AuthApiController::class, 'getProfile']);
    
    // Register as patient (convert app user to patient)
    Route::post('/register-as-patient', [AuthApiController::class, 'registerAsPatient']);
    
    // Pasien routes
    Route::get('/pasien', [PasienApiController::class, 'index']);
    Route::get('/pasien/{pasien}', [PasienApiController::class, 'show']);
    Route::put('/pasien/{pasien}', [PasienApiController::class, 'update']);
    
    // Doctor schedule routes
    Route::get('/jadwal-dokter', [JadwalDokterApiController::class, 'index']);
    Route::get('/jadwal-dokter/{schedule}', [JadwalDokterApiController::class, 'show']);
});