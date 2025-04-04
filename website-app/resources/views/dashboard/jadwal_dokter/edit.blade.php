@extends('layouts.app')

@section('title', 'Edit Jadwal Dokter')
@section('page_title', 'Edit Jadwal Dokter')
@section('page_subtitle', 'Memperbarui informasi jadwal dokter')

@section('content')
<div class="px-4 py-5">
    <!-- Page Header -->
    <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6">
        <div class="flex items-center mb-4 md:mb-0">
            <a href="{{ route('jadwal_dokter.index') }}" class="mr-3 text-gray-500 hover:text-gray-700 transition-colors">
                <i class="fas fa-arrow-left"></i>
            </a>
            <h1 class="text-2xl font-bold text-gray-800 flex items-center">
                <i class="fas fa-calendar-alt text-amber-500 mr-3"></i>
                Edit Jadwal Dokter
            </h1>
            <span class="ml-3 bg-blue-100 text-blue-800 text-xs font-semibold px-2.5 py-0.5 rounded-full flex items-center">
                ID: {{ $schedule->id }}
            </span>
        </div>
        <div class="flex items-center space-x-3">
            <a href="{{ route('jadwal_dokter.index') }}" class="inline-flex items-center px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors focus:ring-4 focus:ring-gray-200">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 10h16M4 14h16M4 18h16" />
                </svg>
                Daftar Jadwal
            </a>
        </div>
    </div>

    <!-- Form Card -->
    <div class="bg-white rounded-xl shadow-md overflow-hidden border border-gray-100">
        <div class="bg-gradient-to-r from-amber-500 to-amber-600 px-6 py-4">
            <h2 class="text-lg font-semibold text-white flex items-center">
                <i class="fas fa-clipboard-list mr-2"></i>
                Edit Jadwal Dokter: {{ $schedule->doctor->name }}
            </h2>
            <p class="text-amber-100 text-sm mt-1">Perbarui jadwal dokter dengan informasi terbaru</p>
        </div>
        <div class="p-6">
            <form action="{{ route('jadwal_dokter.update', $schedule->id) }}" method="POST">
                @csrf
                @method('PUT')
                
                <!-- Form Sections -->
                <div class="grid grid-cols-1 gap-8">
                    <!-- Informasi Jadwal -->
                    <div>
                        <h3 class="text-lg font-medium text-gray-800 mb-3 pb-2 border-b border-gray-200">
                            <i class="fas fa-calendar-alt text-amber-600 mr-2"></i>
                            Informasi Jadwal
                        </h3>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <!-- Dokter -->
                            <div>
                                <label for="doctor_id" class="block text-sm font-medium text-gray-700 mb-1">
                                    Dokter <span class="text-red-500">*</span>
                                </label>
                                <select id="doctor_id" name="doctor_id" 
                                    class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-amber-500 focus:border-amber-500 block w-full p-2.5 @error('doctor_id') border-red-500 @enderror" 
                                    required>
                                    @foreach($doctors as $doctor)
                                        <option value="{{ $doctor->id }}" {{ $schedule->doctor_id == $doctor->id ? 'selected' : '' }}>
                                            {{ $doctor->nama }}
                                        </option>
                                    @endforeach
                                </select>
                                @error('doctor_id')
                                    <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                                @enderror
                            </div>

                            <!-- Hari -->
                            <div>
                                <label for="day_of_week" class="block text-sm font-medium text-gray-700 mb-1">
                                    Hari <span class="text-red-500">*</span>
                                </label>
                                <select id="day_of_week" name="day_of_week" 
                                    class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-amber-500 focus:border-amber-500 block w-full p-2.5 @error('day_of_week') border-red-500 @enderror" 
                                    required>
                                    <option value="1" {{ $schedule->day_of_week == 1 ? 'selected' : '' }}>Senin</option>
                                    <option value="2" {{ $schedule->day_of_week == 2 ? 'selected' : '' }}>Selasa</option>
                                    <option value="3" {{ $schedule->day_of_week == 3 ? 'selected' : '' }}>Rabu</option>
                                    <option value="4" {{ $schedule->day_of_week == 4 ? 'selected' : '' }}>Kamis</option>
                                    <option value="5" {{ $schedule->day_of_week == 5 ? 'selected' : '' }}>Jumat</option>
                                    <option value="6" {{ $schedule->day_of_week == 6 ? 'selected' : '' }}>Sabtu</option>
                                    <option value="7" {{ $schedule->day_of_week == 7 ? 'selected' : '' }}>Minggu</option>
                                </select>
                                @error('day_of_week')
                                    <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                                @enderror
                            </div>

                            <!-- Jam Mulai -->
                            <div>
                                <label for="start_time" class="block text-sm font-medium text-gray-700 mb-1">
                                    Jam Mulai <span class="text-red-500">*</span>
                                </label>
                                <input type="time" id="start_time" name="start_time" value="{{ $schedule->start_time }}" 
                                    class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-amber-500 focus:border-amber-500 block w-full p-2.5 @error('start_time') border-red-500 @enderror" 
                                    required>
                                @error('start_time')
                                    <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                                @enderror
                            </div>

                            <!-- Jam Selesai -->
                            <div>
                                <label for="end_time" class="block text-sm font-medium text-gray-700 mb-1">
                                    Jam Selesai <span class="text-red-500">*</span>
                                </label>
                                <input type="time" id="end_time" name="end_time" value="{{ $schedule->end_time }}" 
                                    class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-amber-500 focus:border-amber-500 block w-full p-2.5 @error('end_time') border-red-500 @enderror" 
                                    required>
                                @error('end_time')
                                    <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                                @enderror
                            </div>

                            <!-- Cluster -->
                            <div>
                                <label for="cluster_id" class="block text-sm font-medium text-gray-700 mb-1">
                                    Cluster <span class="text-red-500">*</span>
                                </label>
                                <select id="cluster_id" name="cluster_id" 
                                    class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-amber-500 focus:border-amber-500 block w-full p-2.5 @error('cluster_id') border-red-500 @enderror" 
                                    required>
                                    @foreach($clusters as $cluster)
                                        <option value="{{ $cluster->id }}" {{ $schedule->cluster_id == $cluster->id ? 'selected' : '' }}>
                                            {{ $cluster->nama }}
                                        </option>
                                    @endforeach
                                </select>
                                @error('cluster_id')
                                    <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                                @enderror
                            </div>

                            <!-- Status -->
                            <div>
                                <label for="status" class="block text-sm font-medium text-gray-700 mb-1">
                                    Status <span class="text-red-500">*</span>
                                </label>
                                <select id="status" name="status" 
                                    class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-amber-500 focus:border-amber-500 block w-full p-2.5 @error('status') border-red-500 @enderror" 
                                    required>
                                    <option value="active" {{ $schedule->status == 'active' ? 'selected' : '' }}>Aktif</option>
                                    <option value="inactive" {{ $schedule->status == 'inactive' ? 'selected' : '' }}>Tidak Aktif</option>
                                </select>
                                @error('status')
                                    <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                                @enderror
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="flex justify-end items-center space-x-3 mt-8 pt-5 border-t border-gray-200">
                    <a href="{{ route('jadwal_dokter.index') }}" class="inline-flex items-center px-4 py-2.5 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors focus:ring-4 focus:ring-gray-200">
                        <i class="fas fa-times mr-2"></i>
                        Batal
                    </a>
                    <button type="submit" class="inline-flex items-center px-5 py-2.5 bg-amber-600 text-white font-medium rounded-lg hover:bg-amber-700 transition-colors focus:ring-4 focus:ring-amber-300">
                        <i class="fas fa-save mr-2"></i>
                        Simpan Perubahan
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
@endsection