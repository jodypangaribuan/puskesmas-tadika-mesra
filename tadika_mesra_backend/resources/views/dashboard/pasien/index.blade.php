@extends('layouts.app')

@section('title', 'Daftar Pasien')
@section('page_title', 'Daftar Pasien')
@section('page_subtitle', 'Mengelola data pasien puskesmas')

@section('content')
<div class="px-4 py-5">
    <!-- Header -->
    <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6 gap-4">
        <div class="w-full md:w-2/5">
            <div class="relative">
                <div class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
                    <i class="fas fa-search text-gray-400"></i>
                </div>
                <input type="text" id="search-input" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-green-500 focus:border-green-500 block w-full pl-10 p-2.5" placeholder="Cari pasien berdasarkan nama, nomor RM...">
            </div>
        </div>
        <a href="{{ route('pasien.create') }}" class="inline-flex items-center px-4 py-2.5 bg-green-600 text-white font-medium text-sm rounded-lg hover:bg-green-700 focus:ring-4 focus:ring-green-300 transition-colors">
            <i class="fas fa-plus mr-2"></i>
            Tambah Pasien Baru
        </a>
    </div>

    <!-- Alert Messages -->
    @if(session('success'))
    <div class="p-4 mb-6 rounded-lg bg-green-50 border-l-4 border-green-500 relative" role="alert">
        <div class="flex items-center">
            <i class="fas fa-check-circle text-green-500 mr-3 text-lg"></i>
            <span class="text-green-800 font-medium">{{ session('success') }}</span>
        </div>
        <button type="button" class="absolute top-4 right-4 text-green-600 hover:text-green-800" onclick="this.parentElement.style.display='none'">
            <i class="fas fa-times"></i>
        </button>
    </div>
    @endif

    <!-- Data Table -->
    <div class="bg-white rounded-xl shadow-md overflow-hidden border border-gray-100">
        <div class="p-5 border-b border-gray-200 bg-gray-50/80">
            <div class="flex justify-between items-center">
                <h2 class="text-lg font-semibold text-gray-800 flex items-center">
                    <i class="fas fa-user-injured mr-2 text-green-600"></i>
                    Data Pasien
                </h2>
                <span class="bg-blue-100 text-blue-800 text-xs font-medium px-2.5 py-0.5 rounded-full">Total: {{ $pasiens->total() }}</span>
            </div>
        </div>
        <div class="p-6">
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200 table-fixed" id="dataTable">
                    <thead>
                        <tr class="bg-gray-50 border-b">
                            <th scope="col" class="py-3.5 px-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider w-28">
                                No. RM
                            </th>
                            <th scope="col" class="py-3.5 px-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Nama
                            </th>
                            <th scope="col" class="py-3.5 px-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Jenis Kelamin
                            </th>
                            <th scope="col" class="py-3.5 px-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Usia
                            </th>
                            <th scope="col" class="py-3.5 px-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider hidden md:table-cell">
                                Alamat
                            </th>
                            <th scope="col" class="py-3.5 px-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider hidden md:table-cell">
                                No. Telepon
                            </th>
                            <th scope="col" class="py-3.5 px-4 text-center text-xs font-medium text-gray-500 uppercase tracking-wider w-28">
                                Aksi
                            </th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        @forelse($pasiens as $pasien)
                        <tr class="hover:bg-gray-50 transition-colors">
                            <td class="py-4 px-4 text-sm font-medium text-gray-900 whitespace-nowrap">
                                <div class="px-2.5 py-1.5 bg-blue-100 text-blue-800 rounded-md font-medium text-xs inline-block">
                                    {{ $pasien->no_rm }}
                                </div>
                            </td>
                            <td class="py-4 px-4 text-sm text-gray-900 font-medium whitespace-nowrap">
                                <div class="flex items-center">
                                    <div class="h-9 w-9 flex-shrink-0 rounded-full bg-gray-100 flex items-center justify-center border border-gray-200 mr-3">
                                        <i class="fas {{ $pasien->jenis_kelamin == 'Laki-laki' ? 'fa-male text-blue-500' : 'fa-female text-pink-500' }}"></i>
                                    </div>
                                    <div class="truncate max-w-[150px]" title="{{ $pasien->nama }}">
                                        {{ $pasien->nama }}
                                    </div>
                                </div>
                            </td>
                            <td class="py-4 px-4 text-sm text-gray-500 whitespace-nowrap">
                                @if($pasien->jenis_kelamin == 'Laki-laki')
                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                                        <i class="fas fa-mars mr-1"></i> Laki-laki
                                    </span>
                                @else
                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-pink-100 text-pink-800">
                                        <i class="fas fa-venus mr-1"></i> Perempuan
                                    </span>
                                @endif
                            </td>
                            <td class="py-4 px-4 text-sm text-gray-500 whitespace-nowrap">
                                <div class="flex items-center">
                                    <i class="fas fa-birthday-cake mr-1.5 text-gray-400"></i>
                                    {{ $pasien->umur }} tahun
                                </div>
                            </td>
                            <td class="py-4 px-4 text-sm text-gray-500 hidden md:table-cell">
                                <div class="truncate max-w-[200px]" title="{{ $pasien->alamat }}">
                                    {{ $pasien->alamat }}
                                </div>
                            </td>
                            <td class="py-4 px-4 text-sm text-gray-500 whitespace-nowrap hidden md:table-cell">
                                @if($pasien->no_telepon)
                                <div class="flex items-center">
                                    <i class="fas fa-phone-alt mr-1.5 text-gray-400"></i>
                                    {{ $pasien->no_telepon }}
                                </div>
                                @else
                                <span class="text-gray-400">-</span>
                                @endif
                            </td>
                            <td class="py-4 px-4 text-sm text-center whitespace-nowrap">
                                <div class="flex justify-center space-x-1">
                                    <a href="{{ route('pasien.show', $pasien->id) }}" class="text-white bg-blue-600 hover:bg-blue-700 p-2 rounded-lg transition-colors" title="Lihat Detail">
                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="w-4 h-4">
                                            <path d="M10 12.5a2.5 2.5 0 100-5 2.5 2.5 0 000 5z" />
                                            <path fill-rule="evenodd" d="M.664 10.59a1.651 1.651 0 010-1.186A10.004 10.004 0 0110 3c4.257 0 7.893 2.66 9.336 6.41.147.381.146.804 0 1.186A10.004 10.004 0 0110 17c-4.257 0-7.893-2.66-9.336-6.41zM14 10a4 4 0 11-8 0 4 4 0 018 0z" clip-rule="evenodd" />
                                        </svg>
                                    </a>
                                    <a href="{{ route('pasien.edit', $pasien->id) }}" class="text-white bg-amber-500 hover:bg-amber-600 p-2 rounded-lg transition-colors" title="Edit Pasien">
                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="w-4 h-4">
                                            <path d="M5.433 13.917l1.262-3.155A4 4 0 017.58 9.42l6.92-6.918a2.121 2.121 0 013 3l-6.92 6.918c-.383.383-.84.685-1.343.886l-3.154 1.262a.5.5 0 01-.65-.65z" />
                                            <path d="M3.5 5.75c0-.69.56-1.25 1.25-1.25H10A.75.75 0 0010 3H4.75A2.75 2.75 0 002 5.75v9.5A2.75 2.75 0 004.75 18h9.5A2.75 2.75 0 0017 15.25V10a.75.75 0 00-1.5 0v5.25c0 .69-.56 1.25-1.25 1.25h-9.5c-.69 0-1.25-.56-1.25-1.25v-9.5z" />
                                        </svg>
                                    </a>
                                    <button type="button" 
                                            class="text-white bg-red-600 hover:bg-red-700 p-2 rounded-lg transition-colors delete-btn" 
                                            title="Hapus Pasien"
                                            data-id="{{ $pasien->id }}"
                                            data-name="{{ $pasien->nama }}">
                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="w-4 h-4">
                                            <path fill-rule="evenodd" d="M8.75 1A2.75 2.75 0 006 3.75v.443c-.795.077-1.584.176-2.365.298a.75.75 0 10.23 1.482l.149-.022.841 10.518A2.75 2.75 0 007.596 19h4.807a2.75 2.75 0 002.742-2.53l.841-10.52.149.023a.75.75 0 00.23-1.482A41.03 41.03 0 0014 4.193V3.75A2.75 2.75 0 0011.25 1h-2.5zM10 4c.84 0 1.673.025 2.5.075V3.75c0-.69-.56-1.25-1.25-1.25h-2.5c-.69 0-1.25.56-1.25 1.25v.325C8.327 4.025 9.16 4 10 4zM8.58 7.72a.75.75 0 00-1.5.06l.3 7.5a.75.75 0 101.5-.06l-.3-7.5zm4.34.06a.75.75 0 10-1.5-.06l-.3 7.5a.75.75 0 101.5.06l.3-7.5z" clip-rule="evenodd" />
                                        </svg>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        @empty
                        <tr>
                            <td colspan="7" class="py-8 text-center">
                                <div class="flex flex-col items-center justify-center">
                                    <i class="fas fa-user-slash text-gray-300 text-5xl mb-4"></i>
                                    <p class="text-gray-500 text-lg">Belum ada data pasien</p>
                                    <p class="text-gray-400 text-sm mt-1">Tambahkan pasien baru untuk memulai</p>
                                    <a href="{{ route('pasien.create') }}" class="mt-3 inline-flex items-center px-3 py-2 bg-green-600 text-white text-sm font-medium rounded-lg hover:bg-green-700">
                                        <i class="fas fa-plus mr-2"></i> Tambah Pasien
                                    </a>
                                </div>
                            </td>
                        </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
            
            <!-- Pagination -->
            <div class="flex justify-between items-center mt-6">
                <p class="text-sm text-gray-500">
                    Menampilkan {{ $pasiens->firstItem() ?? 0 }} - {{ $pasiens->lastItem() ?? 0 }} dari {{ $pasiens->total() }} pasien
                </p>
                {{ $pasiens->links() }}
            </div>
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div id="delete-modal" class="fixed inset-0 z-50 hidden overflow-y-auto" aria-labelledby="modal-title" role="dialog" aria-modal="true">
    <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
        <!-- Background overlay -->
        <div id="modal-backdrop" class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"></div>
        
        <!-- Modal panel -->
        <div class="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
            <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                <div class="sm:flex sm:items-start">
                    <div class="mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full bg-red-100 sm:mx-0 sm:h-10 sm:w-10">
                        <i class="fas fa-exclamation-triangle text-red-600"></i>
                    </div>
                    <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
                        <h3 class="text-lg leading-6 font-medium text-gray-900" id="modal-title">
                            Konfirmasi Hapus
                        </h3>
                        <div class="mt-2">
                            <p class="text-sm text-gray-500" id="modal-message">
                                Apakah Anda yakin ingin menghapus data pasien ini? Proses ini tidak dapat dibatalkan.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
                <form id="delete-form" action="" method="POST">
                    @csrf
                    @method('DELETE')
                    <button type="submit" class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-red-600 text-base font-medium text-white hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 sm:ml-3 sm:w-auto sm:text-sm">
                        Ya, Hapus Data
                    </button>
                </form>
                <button type="button" id="cancel-btn" class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm">
                    Batal
                </button>
            </div>
        </div>
    </div>
</div>
@endsection

@push('scripts')
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Search filter
        const searchInput = document.getElementById('search-input');
        const table = document.getElementById('dataTable');
        const rows = table.querySelectorAll('tbody tr');
        
        searchInput.addEventListener('keyup', function(e) {
            const text = e.target.value.toLowerCase();
            
            rows.forEach(row => {
                const rowText = row.textContent.toLowerCase();
                row.style.display = rowText.includes(text) ? '' : 'none';
            });
        });
        
        // Delete confirmation modal
        const modal = document.getElementById('delete-modal');
        const modalBackdrop = document.getElementById('modal-backdrop');
        const cancelBtn = document.getElementById('cancel-btn');
        const deleteForm = document.getElementById('delete-form');
        const modalMessage = document.getElementById('modal-message');
        const deleteButtons = document.querySelectorAll('.delete-btn');
        
        // Open modal
        deleteButtons.forEach(button => {
            button.addEventListener('click', function() {
                const id = this.getAttribute('data-id');
                const name = this.getAttribute('data-name');
                
                deleteForm.setAttribute('action', `/pasien/${id}`);
                modalMessage.textContent = `Apakah Anda yakin ingin menghapus data pasien "${name}"? Proses ini tidak dapat dibatalkan.`;
                
                modal.classList.remove('hidden');
                document.body.classList.add('overflow-hidden');
            });
        });
        
        // Close modal
        function closeModal() {
            modal.classList.add('hidden');
            document.body.classList.remove('overflow-hidden');
        }
        
        cancelBtn.addEventListener('click', closeModal);
        modalBackdrop.addEventListener('click', closeModal);
    });
</script>
@endpush 