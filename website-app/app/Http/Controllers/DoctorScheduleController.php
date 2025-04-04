<?php

namespace App\Http\Controllers;

use App\Models\Doctor;
use App\Models\Cluster;
use App\Models\DoctorSchedule;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class DoctorScheduleController extends Controller
{
    private function getDayName($day)
    {
        $days = [
            1 => 'Senin',
            2 => 'Selasa',
            3 => 'Rabu',
            4 => 'Kamis',
            5 => 'Jumat',
            6 => 'Sabtu',
            7 => 'Minggu'
        ];
        
        return $days[$day] ?? '';
    }

    public function index()
    {
        $doctor_schedules = DoctorSchedule::with(['doctor', 'cluster'])->latest()->paginate(7);
        
        // Transform numeric days to day names
        $doctor_schedules->getCollection()->transform(function ($schedule) {
            $schedule->day_of_week = $this->getDayName($schedule->day_of_week);
            return $schedule;
        });

        return view('dashboard.jadwal_dokter.index', compact('doctor_schedules'));
    }

    public function create()
    {
        // Ambil semua data dokter dan cluster
        $doctors = Doctor::all();
        $clusters = Cluster::all();
        return view('dashboard.jadwal_dokter.create', compact('doctors', 'clusters'));
    }

    public function store(Request $request)
    {
        // Validasi input
        $validator = Validator::make($request->all(), [
            'doctor_id' => 'required|exists:doctors,id',
            'day_of_week' => 'required|integer|between:1,7',
            'start_time' => 'required|date_format:H:i',
            'end_time' => 'required|date_format:H:i|after:start_time',
            'cluster_id' => 'required|exists:clusters,id',
            'status' => 'required|in:active,inactive',
        ]);

        if ($validator->fails()) {
            return redirect()->route('jadwal_dokter.create')
                ->withErrors($validator)
                ->withInput();
        }

        // Simpan data jadwal dokter
        DoctorSchedule::create($request->all());

        return redirect()->route('jadwal_dokter.index')
            ->with('success', 'Jadwal dokter berhasil ditambahkan.');
    }

    public function show($id)
    {
        // Ambil data jadwal dokter dengan relasi dokter dan cluster
        $schedule = DoctorSchedule::with(['doctor', 'cluster'])->findOrFail($id);
        return view('dashboard.jadwal_dokter.show', compact('schedule'));
    }

    public function edit($id)
    {
        // Ambil data jadwal dokter dengan relasi dokter dan cluster
        $schedule = DoctorSchedule::with(['doctor', 'cluster'])->findOrFail($id);
        $doctors = Doctor::all();
        $clusters = Cluster::all();
        return view('dashboard.jadwal_dokter.edit', compact('schedule', 'doctors', 'clusters'));
    }

    public function update(Request $request, $id)
    {
        // Ambil data jadwal dokter
        $schedule = DoctorSchedule::findOrFail($id);

        // Validasi input
        $request->validate([
            'doctor_id' => 'sometimes|exists:doctors,id',
            'day_of_week' => 'sometimes|integer|between:1,7',
            'start_time' => 'sometimes|date_format:H:i',
            'end_time' => 'sometimes|date_format:H:i|after:start_time',
            'cluster_id' => 'sometimes|exists:clusters,id',
            'status' => 'sometimes|in:active,inactive',
        ]);

        // Update data jadwal dokter
        $schedule->update($request->all());

        return redirect()->route('jadwal_dokter.index')
            ->with('success', 'Jadwal dokter berhasil diperbarui.');
    }

    public function destroy($id)
    {
        // Hapus data jadwal dokter
        $doctor_schedule = DoctorSchedule::findOrFail($id);
        $doctor_schedule->delete();

        return redirect()->route('jadwal_dokter.index')
            ->with('success', 'Jadwal dokter berhasil dihapus.');
    }
}