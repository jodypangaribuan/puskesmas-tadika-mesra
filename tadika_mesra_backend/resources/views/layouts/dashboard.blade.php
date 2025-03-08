<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>{{ config('app.name', 'Puskesmas Dashboard') }} - @yield('title')</title>
    
    <!-- Favicon -->
    <link rel="shortcut icon" href="{{ asset('images/favicon.png') }}">
    
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Styles -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --primary-color: #0f766e; /* Hijau teal sebagai warna utama */
            --primary-light: #14b8a6; /* Hijau teal lebih terang */
            --primary-medium: #0d9488; /* Medium hijau teal untuk aksen */
            --primary-dark: #115e59;  /* Hijau teal gelap */
            --primary-deeper: #134e4a; /* Hijau teal sangat gelap */
            --primary-very-light: #ccfbf1; /* Hijau teal sangat terang */
            --primary-ultra-light: #f0fdfa; /* Hijau teal ultra terang untuk background */
            --success-color: #059669; /* Success green */
            --danger-color: #dc2626; /* Red for errors/danger */
            --warning-color: #f59e0b; /* Amber for warnings */
            --info-color: #0ea5e9; /* Sky blue for info */
            --body-bg: #f0fdfa; /* Light teal background */
            --card-bg: #ffffff; /* Card background */
            --sidebar-bg: #ffffff; /* White sidebar background */
            --sidebar-hover: #f1f5f9; /* Light grey hover for sidebar */
            --sidebar-active: #e2e8f0; /* Slightly darker grey for active items */
            --header-bg: #ffffff; /* Header background */
            --footer-bg: #ffffff; /* Footer background */
            --text-primary: #334155; /* Slate text color for better readability */
            --text-secondary: #64748b; /* Secondary text color */
            --text-sidebar: #334155; /* Dark text for sidebar */
            --text-sidebar-muted: #64748b; /* Muted text for sidebar */
            --border-color: #e2e8f0; /* Border color */
            --accent-color: #0f766e; /* Teal accent for buttons/links */
            --accent-light: #ccfbf1; /* Light teal for backgrounds */
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--body-bg);
            color: var(--text-primary);
            font-size: 14px;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='100' height='100' viewBox='0 0 100 100'%3E%3Cpath fill='%2399f6e4' fill-opacity='0.1' d='M11 18c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm48 25c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm-43-7c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm63 31c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM34 90c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm56-76c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM12 86c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm28-65c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm23-11c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm-6 60c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm29 22c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zM32 63c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm57-13c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5z'%3E%3C/path%3E%3C/svg%3E");
        }
        
        /* Dashboard Layout */
        .dashboard-container {
            display: flex;
            min-height: 100vh;
            position: relative;
        }
        
        /* Sidebar */
        .sidebar {
            width: 260px;
            background-color: var(--sidebar-bg);
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.05);
            position: fixed;
            height: 100vh;
            z-index: 10;
            color: var(--text-sidebar);
            border-right: 1px solid var(--border-color);
        }
        
        .sidebar .logo-container {
            padding: 20px;
            text-align: center;
            border-bottom: 1px solid var(--border-color);
        }
        
        .sidebar .logo {
            height: 50px;
        }
        
        .sidebar-header {
            padding: 20px 25px;
            display: flex;
            align-items: center;
            border-bottom: 1px solid var(--border-color);
        }
        
        .sidebar-header .avatar {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            overflow: hidden;
            margin-right: 15px;
        }
        
        .sidebar-header h2 {
            font-size: 16px;
            margin: 0;
            font-weight: 600;
            color: var(--text-sidebar);
        }
        
        .sidebar-nav {
            padding: 15px 0;
            margin-bottom: auto;
        }
        
        .sidebar-nav .nav-header {
            padding: 12px 25px;
            text-transform: uppercase;
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0.5px;
            color: var(--text-sidebar-muted);
        }
        
        .sidebar-nav .nav-item {
            margin-bottom: 5px;
        }
        
        .sidebar-nav .nav-link {
            padding: 12px 20px;
            display: flex;
            align-items: center;
            color: var(--text-sidebar);
            border-radius: 0;
            transition: all 0.3s;
            border-left: 3px solid transparent;
        }
        
        .sidebar-nav .nav-link i {
            margin-right: 15px;
            font-size: 16px;
            width: 20px;
            text-align: center;
            color: var(--text-secondary);
        }
        
        .sidebar-nav .nav-link:hover {
            background-color: var(--sidebar-hover);
            color: var(--primary-color);
            border-left-color: var(--primary-color);
        }
        
        .sidebar-nav .nav-link:hover i,
        .sidebar-nav .nav-item.active .nav-link i {
            color: var(--primary-color);
        }
        
        .sidebar-nav .nav-item.active .nav-link {
            background-color: var(--sidebar-active);
            color: var(--primary-color);
            border-left-color: var(--primary-color);
        }
        
        /* Main Content */
        .main-content {
            flex: 1;
            margin-left: 260px;
            transition: all 0.3s;
        }
        
        /* Topbar */
        .topbar {
            background-color: var(--header-bg);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.03);
            border-bottom: 1px solid var(--border-color);
            padding: 15px 30px;
            display: flex;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 99;
        }
        
        .menu-toggle {
            background: none;
            border: none;
            color: #718096;
            font-size: 18px;
            cursor: pointer;
            margin-right: 20px;
            display: none;
        }
        
        /* Content Wrapper */
        .content-wrapper {
            padding: 30px;
            animation: fadeIn 0.5s ease-in-out;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        /* Responsive */
        @media (max-width: 992px) {
            .sidebar {
                left: -260px;
            }
            
            .menu-toggle {
                display: block;
            }
            
            .main-content {
                margin-left: 0;
            }
            
            .sidebar.shown {
                left: 0;
            }
        }
        
        /* Additional custom styling for the new palette */
        .bg-primary-light {
            background-color: var(--primary-very-light) !important;
        }
        
        .text-primary-dark {
            color: var(--primary-dark) !important;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover, .btn-primary:focus {
            background-color: var(--primary-dark);
            border-color: var(--primary-dark);
            box-shadow: 0 4px 10px rgba(15, 118, 110, 0.3);
        }
        
        .btn-outline-primary {
            color: var(--primary-color);
            border-color: var(--primary-color);
            transition: all 0.3s ease;
        }
        
        .btn-outline-primary:hover, .btn-outline-primary:focus {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
            box-shadow: 0 4px 10px rgba(15, 118, 110, 0.3);
        }
        
        .card {
            border: none;
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.04);
            border-radius: 10px;
            transition: transform 0.2s, box-shadow 0.2s;
            overflow: hidden;
        }
        
        .card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
        }
        
        .card-header {
            border-bottom: 1px solid var(--border-color);
            background-color: white;
            padding: 15px 20px;
        }
        
        .card-body {
            padding: 20px;
        }
        
        /* Cards can have teal accent on top */
        .card-accent-primary {
            border-top: 3px solid var(--primary-color);
        }
        
        .card-accent-success {
            border-top: 3px solid var(--success-color);
        }
        
        .card-accent-warning {
            border-top: 3px solid var(--warning-color);
        }
        
        .card-accent-danger {
            border-top: 3px solid var(--danger-color);
        }
        
        /* Badges styling */
        .badge {
            font-weight: 500;
            padding: 5px 10px;
            border-radius: 6px;
        }
        
        .badge-primary, .bg-primary-light {
            background-color: var(--primary-very-light) !important;
            color: var(--primary-dark) !important;
        }
        
        .bg-accent-light {
            background-color: var(--primary-very-light) !important;
        }
        
        .text-accent-dark {
            color: var(--primary-dark) !important;
        }
        
        .badge-success, .bg-success-light {
            background-color: #d1fae5 !important;
            color: #065f46 !important;
        }
        
        .badge-warning, .bg-warning-light {
            background-color: #fef3c7 !important;
            color: #92400e !important;
        }
        
        .badge-danger, .bg-danger-light {
            background-color: #fee2e2 !important;
            color: #b91c1c !important;
        }
        
        /* User section */
        .sidebar-user {
            padding: 20px;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            align-items: center;
        }
        
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            overflow: hidden;
            background-color: var(--primary-light);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .user-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .default-avatar {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
        }
        
        .user-info h6 {
            color: var(--text-sidebar);
            margin-bottom: 5px;
        }
        
        /* Footer styling */
        footer {
            background-color: white;
            border-top: 1px solid var(--border-color);
            padding: 15px 30px;
            color: var(--text-secondary);
        }
        
        /* Table styling */
        .table {
            border-collapse: separate;
            border-spacing: 0;
        }
        
        .table thead th {
            background-color: rgba(15, 118, 110, 0.05);
            border-bottom: 1px solid var(--border-color);
            color: var(--primary-dark);
            font-weight: 600;
            padding: 12px 15px;
        }
        
        .table tbody td {
            padding: 12px 15px;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
        }
        
        .table-hover tbody tr:hover {
            background-color: rgba(15, 118, 110, 0.02);
        }
        
        /* Form controls */
        .form-control:focus, .form-select:focus {
            border-color: var(--primary-light);
            box-shadow: 0 0 0 0.25rem rgba(15, 118, 110, 0.15);
        }
        
        /* Page title */
        .topbar-title h4 {
            color: var(--text-primary);
            font-weight: 600;
            margin: 0;
            position: relative;
            padding-left: 12px;
        }
        
        .topbar-title h4:before {
            content: '';
            position: absolute;
            left: 0;
            top: 50%;
            transform: translateY(-50%);
            height: 70%;
            width: 4px;
            background: linear-gradient(to bottom, var(--primary-color), var(--primary-light));
            border-radius: 4px;
        }
    </style>
    
    @stack('styles')
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <img src="{{ asset('images/puskesmas-logo.png') }}" alt="Puskesmas Logo" class="sidebar-logo">
                <h5>PUSKESMAS</h5>
            </div>
            
            <div class="sidebar-user">
                <div class="user-avatar">
                    @if(Auth::user()->profile_photo)
                        <img src="{{ asset('storage/'.Auth::user()->profile_photo) }}" alt="{{ Auth::user()->name }}">
                    @else
                        <div class="default-avatar">
                            {{ strtoupper(substr(Auth::user()->name, 0, 1)) }}
                        </div>
                    @endif
                </div>
                <div class="user-info">
                    <h6 class="mb-1 fw-semibold">{{ Auth::user()->name }}</h6>
                    <span class="badge bg-accent-light text-primary-dark">{{ ucfirst(Auth::user()->role) }}</span>
                </div>
            </div>
            
            <nav class="sidebar-nav">
                <ul class="nav flex-column">
                    <li class="nav-item {{ request()->is('dashboard') ? 'active' : '' }}">
                        <a href="{{ route('dashboard') }}" class="nav-link">
                            <i class="fas fa-home"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    
                    @if(Auth::user()->isAdmin() || Auth::user()->isDoctor())
                    <li class="nav-item {{ request()->is('patients*') ? 'active' : '' }}">
                        <a href="#" class="nav-link">
                            <i class="fas fa-user-injured"></i>
                            <span>Pasien</span>
                        </a>
                    </li>
                    @endif
                    
                    @if(Auth::user()->isAdmin() || Auth::user()->isDoctor() || Auth::user()->isNurse())
                    <li class="nav-item {{ request()->is('appointments*') ? 'active' : '' }}">
                        <a href="#" class="nav-link">
                            <i class="fas fa-calendar-check"></i>
                            <span>Jadwal</span>
                        </a>
                    </li>
                    @endif
                    
                    @if(Auth::user()->isAdmin())
                    <li class="nav-item {{ request()->is('users*') ? 'active' : '' }}">
                        <a href="#" class="nav-link">
                            <i class="fas fa-users"></i>
                            <span>Pengguna</span>
                        </a>
                    </li>
                    @endif
                    
                    <li class="nav-item {{ request()->is('profile') ? 'active' : '' }}">
                        <a href="{{ route('profile') }}" class="nav-link">
                            <i class="fas fa-user-circle"></i>
                            <span>Profil</span>
                        </a>
                    </li>
                    
                    <li class="nav-item">
                        <a href="#" class="nav-link" onclick="event.preventDefault(); document.getElementById('logout-form').submit();">
                            <i class="fas fa-sign-out-alt"></i>
                            <span>Keluar</span>
                        </a>
                    </li>
                    
                    <form id="logout-form" action="{{ route('logout') }}" method="POST" class="d-none">
                        @csrf
                    </form>
                </ul>
            </nav>
        </aside>
        
        <!-- Main Content -->
        <main class="main-content">
            <!-- Topbar -->
            <header class="topbar">
                <button class="menu-toggle" id="menu-toggle">
                    <i class="fas fa-bars"></i>
                </button>
                
                <div class="topbar-title">
                    <h4 class="m-0 fw-semibold">@yield('page-title', 'Dashboard')</h4>
                </div>
                
                <div class="ms-auto d-flex align-items-center">
                    <div class="text-muted">
                        <i class="far fa-calendar-alt me-2"></i>
                        <span id="current-date"></span>
                    </div>
                </div>
            </header>
            
            <!-- Content -->
            <div class="content-wrapper">
                @yield('content')
            </div>
            
            <!-- Footer -->
            <footer class="bg-white py-3 px-4 border-top">
                <div class="container-fluid">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <p class="text-muted mb-0">&copy; {{ date('Y') }} Puskesmas. All rights reserved.</p>
                        </div>
                        <div class="col-md-6 text-md-end">
                            <span class="badge bg-primary-light">Version 1.0.0</span>
                        </div>
                    </div>
                </div>
            </footer>
        </main>
    </div>
    
    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script>
        // Toggle sidebar on mobile
        document.getElementById('menu-toggle').addEventListener('click', function() {
            document.querySelector('.sidebar').classList.toggle('shown');
        });
        
        // Current date
        const monthNames = ["Januari", "Februari", "Maret", "April", "Mei", "Juni",
                            "Juli", "Agustus", "September", "Oktober", "November", "Desember"];
        const now = new Date();
        const formattedDate = `${now.getDate()} ${monthNames[now.getMonth()]} ${now.getFullYear()}`;
        document.getElementById('current-date').textContent = formattedDate;
    </script>
    
    @stack('scripts')
</body>
</html> 