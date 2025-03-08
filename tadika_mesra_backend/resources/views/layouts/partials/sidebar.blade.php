<!-- Sidebar -->
<aside class="bg-white shadow-lg h-full text-gray-700" x-data="{ activeDropdown: null }">
    <!-- Logo -->
    <div class="px-6 py-5 border-b border-gray-200 bg-white">
        <div class="flex items-center">
            <img src="{{ asset('images/logo.png') }}" alt="Logo" class="w-10 h-10 mr-3">
            <div>
                <h1 class="text-xl font-bold text-gray-800">PUSKESMAS</h1>
                <p class="text-xs text-gray-500">Tadika Mesra</p>
            </div>
        </div>
    </div>

    <!-- Navigation -->
    <nav class="px-3 py-4 h-[calc(100%-13rem)] overflow-y-auto">
        <div class="mb-3 px-3">
            <p class="text-xs font-semibold text-gray-500 uppercase tracking-wider">Menu Utama</p>
        </div>
        <ul class="space-y-1">
            <li>
                <a href="/dashboard" class="{{ request()->is('dashboard') ? 'flex items-center px-4 py-2.5 text-gray-700 bg-green-100 hover:bg-green-200 rounded-lg transition-colors group' : 'flex items-center px-4 py-2.5 text-gray-600 hover:bg-green-50 hover:text-gray-800 rounded-lg transition-colors group' }}">
                    <i class="fas fa-home w-5 h-5 mr-3 {{ request()->is('dashboard') ? 'text-green-600' : 'text-gray-500 group-hover:text-green-600' }} transition-colors"></i>
                    <span class="{{ request()->is('dashboard') ? 'font-medium' : '' }}">Dashboard</span>
                </a>
            </li>
            <li>
                <a href="/pasien" class="{{ request()->is('pasien*') ? 'flex items-center px-4 py-2.5 text-gray-700 bg-green-100 hover:bg-green-200 rounded-lg transition-colors group' : 'flex items-center px-4 py-2.5 text-gray-600 hover:bg-green-50 hover:text-gray-800 rounded-lg transition-colors group' }}">
                    <i class="fas fa-users w-5 h-5 mr-3 {{ request()->is('pasien*') ? 'text-green-600' : 'text-gray-500 group-hover:text-green-600' }} transition-colors"></i>
                    <span class="{{ request()->is('pasien*') ? 'font-medium' : '' }}">Pasien</span>
                </a>
            </li>
            <li>
                <a href="/appointments" class="flex items-center px-4 py-2.5 text-gray-600 hover:bg-green-50 hover:text-gray-800 rounded-lg transition-colors group">
                    <i class="fas fa-calendar-check w-5 h-5 mr-3 text-gray-500 group-hover:text-green-600 transition-colors"></i>
                    <span>Jadwal Kunjungan</span>
                </a>
            </li>
            <li>
                <a href="/medical-records" class="flex items-center px-4 py-2.5 text-gray-600 hover:bg-green-50 hover:text-gray-800 rounded-lg transition-colors group">
                    <i class="fas fa-notes-medical w-5 h-5 mr-3 text-gray-500 group-hover:text-green-600 transition-colors"></i>
                    <span>Rekam Medis</span>
                </a>
            </li>
            <li>
                <button @click="activeDropdown = activeDropdown === 'services' ? null : 'services'" class="w-full flex items-center justify-between px-4 py-2.5 text-gray-600 hover:bg-green-50 hover:text-gray-800 rounded-lg transition-colors group">
                    <div class="flex items-center">
                        <i class="fas fa-hand-holding-medical w-5 h-5 mr-3 text-gray-500 group-hover:text-green-600 transition-colors"></i>
                        <span>Layanan</span>
                    </div>
                    <i class="fas" :class="activeDropdown === 'services' ? 'fa-chevron-down' : 'fa-chevron-right'"></i>
                </button>
                <div x-show="activeDropdown === 'services'" x-collapse class="pl-12 pr-3 py-1 mt-1 space-y-1">
                    <a href="/pharmacy" class="block py-2 px-3 text-sm text-gray-600 hover:bg-green-50 hover:text-green-700 rounded-lg transition-colors">
                        <i class="fas fa-pills mr-2"></i> Farmasi
                    </a>
                    <a href="/laboratory" class="block py-2 px-3 text-sm text-gray-600 hover:bg-green-50 hover:text-green-700 rounded-lg transition-colors">
                        <i class="fas fa-flask mr-2"></i> Laboratorium
                    </a>
                </div>
            </li>
        </ul>
    </nav>
</aside> 