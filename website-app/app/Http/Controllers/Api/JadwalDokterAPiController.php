<?php 

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\DoctorSchedule;
use Illuminate\Http\Request;

class JadwalDokterApiController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $doctor_schedules = DoctorSchedule::latest()->get();
        return response()->json([
            'success' => true,
            'message' => 'Daftar Jadwal Dokter',
            'data' => $doctor_schedules
        ]);
    }

    /**
     * Display the specified resource.
     */
    public function show(DoctorSchedule $schedule)
    {
        return response()->json([
            'success' => true,
            'message' => 'Detail Jadwal Dokter',
            'data' => $schedule
        ]);
    }
}