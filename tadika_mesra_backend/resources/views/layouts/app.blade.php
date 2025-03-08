<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ config('app.name', 'Puskesmas Dashboard') }} - @yield('title', 'Dashboard')</title>
    
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: {
                            ultralight: '#f0fdf4',
                            verylight: '#dcfce7',
                            light: '#22c55e',
                            medium: '#16a34a',
                            DEFAULT: '#15803d',
                            dark: '#166534',
                            deeper: '#14532d'
                        },
                        green: {
                            50: '#f0fdf4',
                            100: '#dcfce7',
                            200: '#bbf7d0',
                            300: '#86efac',
                            400: '#4ade80',
                            500: '#22c55e',
                            600: '#16a34a',
                            700: '#15803d',
                            800: '#166534',
                            900: '#14532d',
                            950: '#052e16',
                        },
                        success: '#059669',
                        danger: '#dc2626',
                        warning: '#fbbf24',
                        info: '#0284c7'
                    }
                }
            }
        }
    </script>
    
    <!-- Alpine.js -->
    <script defer src="https://unpkg.com/alpinejs@3.10.3/dist/cdn.min.js"></script>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <!-- Custom Styles -->
    <style>
        :root {
            --primary-color: #15803d; /* Hijau tua */
            --primary-light: #22c55e; /* Hijau lebih terang */
            --primary-medium: #16a34a; /* Medium green for accents */
            --primary-dark: #166534;  /* Hijau sangat tua */
            --primary-deeper: #14532d; /* Hijau lebih gelap */
            --primary-very-light: #dcfce7; /* Hijau sangat terang */
            --primary-ultra-light: #f0fdf4; /* Hijau ultra terang for backgrounds */
            --success-color: #059669; /* Success green */
            --danger-color: #dc2626; /* Red for errors/danger */
            --warning-color: #fbbf24; /* Yellow for warnings */
            --info-color: #0284c7; /* Blue for info */
            --body-bg: #f0fdf4; /* Light green background */
            --card-bg: #ffffff; /* Card background */
            --sidebar-bg: #15803d; /* Green sidebar background */
            --sidebar-hover: #166534; /* Darker green for hover states */
            --header-bg: #ffffff; /* Header background */
            --footer-bg: #ffffff; /* Footer background */
        }
        
        body {
            background-color: var(--body-bg); /* Light green background */
            overflow-x: hidden;
            color: #333;
            font-family: 'Inter', 'Segoe UI', Roboto, -apple-system, BlinkMacSystemFont, sans-serif;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='100' height='100' viewBox='0 0 100 100'%3E%3Cpath fill='%2392d9a7' fill-opacity='0.1' d='M11 18c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm48 25c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm-43-7c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm63 31c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM34 90c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm56-76c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM12 86c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm28-65c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm23-11c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm-6 60c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm29 22c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zM32 63c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm57-13c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5z'%3E%3C/path%3E%3C/svg%3E");
        }
        
        /* Fix sidebar to viewport */
        .sidebar-fixed {
            position: fixed;
            top: 0;
            left: 0;
            bottom: 0;
            width: 16rem; /* 64px = 16rem */
            overflow: hidden;
            z-index: 50;
            transition: transform 0.3s ease;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
            background-color: #15803d; /* Green sidebar background */
        }
        
        /* Fix header to viewport */
        .header-fixed {
            position: fixed;
            top: 0;
            right: 0;
            left: 16rem; /* Match sidebar width */
            z-index: 40;
            transition: left 0.3s ease;
            box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
            height: 4.5rem;
        }
        
        /* Main content area that scrolls */
        .content-scrollable {
            margin-top: 4.5rem; /* Match header height */
            margin-left: 16rem; /* Match sidebar width */
            padding: 1.5rem;
            padding-bottom: 5rem; /* Add space for footer */
            height: calc(100vh - 4.5rem); /* Viewport height minus header height */
            overflow-y: auto;
            transition: margin-left 0.3s ease;
            background-color: #f0fdf4; /* Light green background */
        }
        
        /* Footer positioning */
        .footer-container {
            position: fixed;
            bottom: 0;
            right: 0;
            left: 16rem; /* Match sidebar width */
            z-index: 30;
            transition: left 0.3s ease;
            background-color: white;
        }
        
        /* Scrollbar styling */
        ::-webkit-scrollbar {
            width: 6px;
            height: 6px;
        }
        
        ::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }
        
        ::-webkit-scrollbar-thumb {
            background: #cbd5e1;
            border-radius: 10px;
        }
        
        ::-webkit-scrollbar-thumb:hover {
            background: #94a3b8;
        }
        
        /* Collapsed sidebar state */
        .sidebar-collapsed .sidebar-fixed {
            transform: translateX(-16rem);
        }
        
        .sidebar-collapsed .header-fixed,
        .sidebar-collapsed .footer-container {
            left: 0;
        }
        
        .sidebar-collapsed .content-scrollable {
            margin-left: 0;
        }
        
        /* Mobile responsive styles */
        @media (max-width: 1024px) {
            .sidebar-fixed {
                transform: translateX(-16rem);
            }
            
            .header-fixed,
            .footer-container {
                left: 0;
            }
            
            .content-scrollable {
                margin-left: 0;
            }
            
            .sidebar-expanded .sidebar-fixed {
                transform: translateX(0);
            }
            
            .sidebar-expanded .header-fixed,
            .sidebar-expanded .footer-container {
                left: 16rem;
            }
            
            .sidebar-expanded .content-scrollable {
                margin-left: 16rem;
            }
        }
        
        /* Animation for dropdowns */
        [x-cloak] { 
            display: none !important; 
        }
        
        .fade-in-down {
            animation: fadeInDown 0.2s ease-in-out;
        }
        
        @keyframes fadeInDown {
            0% {
                opacity: 0;
                transform: translateY(-10px);
            }
            100% {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
    
    <!-- Extra Styles -->
    @stack('styles')
</head>
<body class="bg-gray-50" x-data="{ sidebarOpen: window.innerWidth >= 1024 }" :class="{ 'sidebar-collapsed': !sidebarOpen, 'sidebar-expanded': sidebarOpen }">
    <!-- Sidebar (Fixed) -->
    <div class="sidebar-fixed">
        @include('layouts.partials.sidebar')
    </div>
    
    <!-- Backdrop for mobile sidebar -->
    <div x-show="sidebarOpen && window.innerWidth < 1024" @click="sidebarOpen = false" class="fixed inset-0 bg-black bg-opacity-50 z-40 lg:hidden" x-cloak></div>
    
    <!-- Header (Fixed) -->
    <div class="header-fixed">
        @include('layouts.partials.header')
    </div>
    
    <!-- Main Content (Scrollable) -->
    <main class="content-scrollable">
        @yield('content')
    </main>
    
    <!-- Footer (Fixed) -->
    <div class="footer-container">
        @include('layouts.partials.footer')
    </div>

    <!-- Scripts Stack -->
    @stack('scripts')
    
    <!-- Sidebar toggle script -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const toggleButton = document.getElementById('toggleSidebar');
            if (toggleButton) {
                toggleButton.addEventListener('click', function() {
                    // Toggle Alpine.js state
                    if (window.Alpine) {
                        window.Alpine.store('sidebarState', window.Alpine.store('sidebarState') || { open: false });
                        window.Alpine.store('sidebarState').open = !window.Alpine.store('sidebarState').open;
                        window.Alpine.data('main').sidebarOpen = window.Alpine.store('sidebarState').open;
                    }
                });
            }
            
            // Handle responsive design
            window.addEventListener('resize', function() {
                const width = window.innerWidth;
                if (width < 1024) {
                    // Mobile view - sidebar closed by default
                    if (window.Alpine) {
                        window.Alpine.data('main') && (window.Alpine.data('main').sidebarOpen = false);
                    }
                    document.body.classList.add('sidebar-collapsed');
                    document.body.classList.remove('sidebar-expanded');
                } else {
                    // Desktop view - sidebar open by default
                    if (window.Alpine) {
                        window.Alpine.data('main') && (window.Alpine.data('main').sidebarOpen = true);
                    }
                    document.body.classList.remove('sidebar-collapsed');
                    document.body.classList.add('sidebar-expanded');
                }
            });
            
            // Add some animations to dropdowns
            const dropdowns = document.querySelectorAll('[x-show]');
            dropdowns.forEach(dropdown => {
                if (!dropdown.hasAttribute('x-transition')) {
                    dropdown.classList.add('fade-in-down');
                }
            });
        });
    </script>
</body>
</html> 