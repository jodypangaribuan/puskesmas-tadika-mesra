<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Pasien;
use Illuminate\Http\Request;

class PasienApiController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $pasiens = Pasien::latest()->get();
        return response()->json([
            'success' => true,
            'message' => 'Daftar Pasien',
            'data' => $pasiens
        ]);
    }

    /**
     * Display the specified resource.
     */
    public function show(Pasien $pasien)
    {
        return response()->json([
            'success' => true,
            'message' => 'Detail Pasien',
            'data' => $pasien
        ]);
    }
}