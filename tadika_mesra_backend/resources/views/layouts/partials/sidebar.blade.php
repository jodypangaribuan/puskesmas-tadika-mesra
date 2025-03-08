<!-- Sidebar -->
<aside class="bg-primary shadow-lg h-full text-white" x-data="{ activeDropdown: null }">
    <!-- Logo -->
    <div class="px-6 py-5 border-b border-primary-dark bg-primary-dark">
        <div class="flex items-center">
            <img src="{{ asset('images/logo.png') }}" alt="Logo" class="w-10 h-10 mr-3">
            <div>
                <h1 class="text-xl font-bold text-white">PUSKESMAS</h1>
                <p class="text-xs text-primary-verylight">Tadika Mesra</p>
            </div>
        </div>
    </div>

    <!-- Navigation -->
    <nav class="px-3 py-4 h-[calc(100%-13rem)] overflow-y-auto">
        <div class="mb-3 px-3">
            <p class="text-xs font-semibold text-primary-verylight uppercase tracking-wider">Menu Utama</p>
        </div>
        <ul class="space-y-1">
            <li>
                <a href="/dashboard" class="flex items-center px-4 py-2.5 text-white bg-primary-dark hover:bg-primary-deeper rounded-lg transition-colors group">
                    <i class="fas fa-home w-5 h-5 mr-3 text-primary-verylight group-hover:text-white transition-colors"></i>
                    <span class="font-medium">Dashboard</span>
                </a>
            </li>
            <li>
                <a href="/patients" class="flex items-center px-4 py-2.5 text-primary-verylight hover:bg-primary-dark hover:text-white rounded-lg transition-colors group">
                    <i class="fas fa-users w-5 h-5 mr-3 text-primary-verylight group-hover:text-white transition-colors"></i>
                    <span>Pasien</span>
                </a>
            </li>
            <li>
                <a href="/appointments" class="flex items-center px-4 py-2.5 text-primary-verylight hover:bg-primary-dark hover:text-white rounded-lg transition-colors group">
                    <i class="fas fa-calendar-check w-5 h-5 mr-3 text-primary-verylight group-hover:text-white transition-colors"></i>
                    <span>Jadwal Kunjungan</span>
                </a>
            </li>
            <li>
                <a href="/medical-records" class="flex items-center px-4 py-2.5 text-primary-verylight hover:bg-primary-dark hover:text-white rounded-lg transition-colors group">
                    <i class="fas fa-notes-medical w-5 h-5 mr-3 text-primary-verylight group-hover:text-white transition-colors"></i>
                    <span>Rekam Medis</span>
                </a>
            </li>
            <li>
                <button @click="activeDropdown = activeDropdown === 'services' ? null : 'services'" class="w-full flex items-center justify-between px-4 py-2.5 text-primary-verylight hover:bg-primary-dark hover:text-white rounded-lg transition-colors group">
                    <div class="flex items-center">
                        <i class="fas fa-hand-holding-medical w-5 h-5 mr-3 text-primary-verylight group-hover:text-white transition-colors"></i>
                        <span>Layanan</span>
                    </div>
                    <i class="fas" :class="activeDropdown === 'services' ? 'fa-chevron-down' : 'fa-chevron-right'"></i>
                </button>
                <div x-show="activeDropdown === 'services'" x-collapse class="pl-12 pr-3 py-1 mt-1 space-y-1">
                    <a href="/pharmacy" class="block py-2 px-3 text-sm text-gray-700 hover:bg-primary/5 hover:text-primary rounded-lg transition-colors">
                        <i class="fas fa-pills mr-2"></i> Farmasi
                    </a>
                    <a href="/laboratory" class="block py-2 px-3 text-sm text-gray-700 hover:bg-primary/5 hover:text-primary rounded-lg transition-colors">
                        <i class="fas fa-flask mr-2"></i> Laboratorium
                    </a>
                </div>
            </li>
        </ul>
        
        <div class="my-3 px-3 pt-4 border-t">
            <p class="text-xs font-semibold text-gray-400 uppercase tracking-wider">Laporan & Utilitas</p>
        </div>
        <ul class="space-y-1">
            <li>
                <a href="/reports" class="flex items-center px-4 py-2.5 text-gray-700 hover:bg-primary/10 hover:text-primary rounded-lg transition-colors group">
                    <i class="fas fa-chart-bar w-5 h-5 mr-3 text-gray-500 group-hover:text-primary transition-colors"></i>
                    <span>Laporan</span>
                </a>
            </li>
            <li>
                <a href="/settings" class="flex items-center px-4 py-2.5 text-gray-700 hover:bg-primary/10 hover:text-primary rounded-lg transition-colors group">
                    <i class="fas fa-cog w-5 h-5 mr-3 text-gray-500 group-hover:text-primary transition-colors"></i>
                    <span>Pengaturan</span>
                </a>
            </li>
        </ul>
    </nav>
    

</aside> 