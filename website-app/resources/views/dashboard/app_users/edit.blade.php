@extends('layouts.app')

@section('title', 'Edit Pengguna Aplikasi')
@section('page_title', 'Edit Pengguna Aplikasi')
@section('page_subtitle', 'Ubah data pengguna aplikasi mobile')

@section('content')
<div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
    <div class="p-6">
        <form action="{{ route('app-users.update', $user->id) }}" method="POST">
            @csrf
            @method('PUT')
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <!-- Basic Information -->
                <div class="bg-gray-50 p-6 rounded-lg shadow-sm">
                    <h3 class="text-lg font-medium text-gray-900 mb-4">Informasi Dasar</h3>
                    
                    <!-- Name -->
                    <div class="mb-4">
                        <label for="name" class="block text-sm font-medium text-gray-700 mb-1">Nama Lengkap <span class="text-red-500">*</span></label>
                        <input type="text" name="name" id="name" value="{{ old('name', $user->name) }}" required
                            class="mt-1 focus:ring-blue-500 focus:border-blue-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md @error('name') border-red-500 @enderror">
                        @error('name')
                            <p class="mt-1 text-sm text-red-500">{{ $message }}</p>
                        @enderror
                    </div>
                    
                    <!-- Email -->
                    <div class="mb-4">
                        <label for="email" class="block text-sm font-medium text-gray-700 mb-1">Email <span class="text-red-500">*</span></label>
                        <input type="email" name="email" id="email" value="{{ old('email', $user->email) }}" required
                            class="mt-1 focus:ring-blue-500 focus:border-blue-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md @error('email') border-red-500 @enderror">
                        @error('email')
                            <p class="mt-1 text-sm text-red-500">{{ $message }}</p>
                        @enderror
                    </div>
                    
                    <!-- Password -->
                    <div class="mb-4">
                        <label for="password" class="block text-sm font-medium text-gray-700 mb-1">Password</label>
                        <input type="password" name="password" id="password" 
                            class="mt-1 focus:ring-blue-500 focus:border-blue-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md @error('password') border-red-500 @enderror">
                        @error('password')
                            <p class="mt-1 text-sm text-red-500">{{ $message }}</p>
                        @enderror
                        <p class="mt-1 text-xs text-gray-500">Kosongkan jika tidak ingin mengubah password</p>
                    </div>
                    
                    <!-- Status -->
                    <div class="mb-4">
                        <label for="is_active" class="block text-sm font-medium text-gray-700 mb-1">Status <span class="text-red-500">*</span></label>
                        <select name="is_active" id="is_active" required
                            class="mt-1 focus:ring-blue-500 focus:border-blue-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md @error('is_active') border-red-500 @enderror">
                            <option value="1" {{ old('is_active', $user->is_active) ? 'selected' : '' }}>Aktif</option>
                            <option value="0" {{ old('is_active', $user->is_active) ? '' : 'selected' }}>Nonaktif</option>
                        </select>
                        @error('is_active')
                            <p class="mt-1 text-sm text-red-500">{{ $message }}</p>
                        @enderror
                    </div>
                </div>
                
                <!-- Additional Information -->
                <div class="bg-gray-50 p-6 rounded-lg shadow-sm">
                    <h3 class="text-lg font-medium text-gray-900 mb-4">Informasi Tambahan</h3>
                    
                    <!-- Phone -->
                    <div class="mb-4">
                        <label for="phone" class="block text-sm font-medium text-gray-700 mb-1">Nomor Telepon</label>
                        <input type="text" name="phone" id="phone" value="{{ old('phone', $user->phone) }}"
                            class="mt-1 focus:ring-blue-500 focus:border-blue-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md @error('phone') border-red-500 @enderror">
                        @error('phone')
                            <p class="mt-1 text-sm text-red-500">{{ $message }}</p>
                        @enderror
                    </div>
                    
                    <!-- NIK -->
                    <div class="mb-4">
                        <label for="nik" class="block text-sm font-medium text-gray-700 mb-1">NIK</label>
                        <input type="text" name="nik" id="nik" value="{{ old('nik', $user->nik) }}" maxlength="16"
                            class="mt-1 focus:ring-blue-500 focus:border-blue-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md @error('nik') border-red-500 @enderror">
                        @error('nik')
                            <p class="mt-1 text-sm text-red-500">{{ $message }}</p>
                        @enderror
                    </div>
                    
                    <!-- Gender -->
                    <div class="mb-4">
                        <label for="gender" class="block text-sm font-medium text-gray-700 mb-1">Jenis Kelamin</label>
                        <select name="gender" id="gender" 
                            class="mt-1 focus:ring-blue-500 focus:border-blue-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md @error('gender') border-red-500 @enderror">
                            <option value="">-- Pilih Jenis Kelamin --</option>
                            <option value="Laki-laki" {{ old('gender', $user->gender) == 'Laki-laki' ? 'selected' : '' }}>Laki-laki</option>
                            <option value="Perempuan" {{ old('gender', $user->gender) == 'Perempuan' ? 'selected' : '' }}>Perempuan</option>
                        </select>
                        @error('gender')
                            <p class="mt-1 text-sm text-red-500">{{ $message }}</p>
                        @enderror
                    </div>
                    
                    <!-- Date of Birth -->
                    <div class="mb-4">
                        <label for="date_of_birth" class="block text-sm font-medium text-gray-700 mb-1">Tanggal Lahir</label>
                        <input type="date" name="date_of_birth" id="date_of_birth" value="{{ old('date_of_birth', $user->date_of_birth ? $user->date_of_birth->format('Y-m-d') : '') }}"
                            class="mt-1 focus:ring-blue-500 focus:border-blue-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md @error('date_of_birth') border-red-500 @enderror">
                        @error('date_of_birth')
                            <p class="mt-1 text-sm text-red-500">{{ $message }}</p>
                        @enderror
                    </div>
                    
                    <!-- Patient Info (if any) -->
                    @if($user->pasien)
                    <div class="mt-6 p-3 bg-blue-50 rounded-md border border-blue-200">
                        <h4 class="text-sm font-medium text-blue-800 mb-2">Informasi Pasien</h4>
                        <div class="text-xs text-blue-700">
                            <p><span class="font-medium">No. RM:</span> {{ $user->pasien->no_rm }}</p>
                            <p><span class="font-medium">Nama Pasien:</span> {{ $user->pasien->nama }}</p>
                            <p><span class="font-medium">Alamat:</span> {{ $user->pasien->alamat }}</p>
                            <a href="{{ route('pasien.edit', $user->pasien->id) }}" class="text-blue-600 hover:underline mt-2 inline-block">
                                <i class="fas fa-edit mr-1"></i> Edit Data Pasien
                            </a>
                        </div>
                    </div>
                    @endif
                </div>
            </div>
            
            <div class="mt-6 flex items-center justify-end space-x-3">
                <a href="{{ route('app-users.index') }}" class="inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md shadow-sm text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                    Batal
                </a>
                <button type="submit" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                    Simpan Perubahan
                </button>
            </div>
        </form>
    </div>
</div>
@endsection 