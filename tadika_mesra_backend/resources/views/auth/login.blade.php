@extends('layouts.app')

@section('title', 'Login')

@push('styles')
<style>
    body {
        background-color: var(--body-bg); /* Light green background */
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='100' height='100' viewBox='0 0 100 100'%3E%3Cpath fill='%2392d9a7' fill-opacity='0.1' d='M11 18c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm48 25c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm-43-7c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm63 31c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM34 90c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm56-76c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM12 86c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm28-65c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm23-11c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm-6 60c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm29 22c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zM32 63c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm57-13c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5z'%3E%3C/path%3E%3C/svg%3E");
    }
    
    .login-container {
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 20px;
    }
    
    .login-card {
        width: 100%;
        max-width: 420px;
        background-color: white;
        border-radius: 12px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        padding: 32px;
        position: relative;
        overflow: hidden;
    }
    
    .login-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 5px;
        background-color: var(--primary-color);
    }
    
    .login-logo {
        margin-bottom: 30px;
        display: flex;
        justify-content: center;
    }
    
    .login-logo img {
        width: 56px;
        height: auto;
    }
    
    .login-title {
        text-align: center;
        margin-bottom: 24px;
    }
    
    .form-group {
        margin-bottom: 20px;
    }
    
    .form-control {
        width: 100%;
        padding: 12px 16px;
        border: 1px solid #ddd;
        border-radius: 8px;
        transition: all 0.3s;
        font-size: 15px;
    }
    
    .form-control:focus {
        border-color: var(--primary-color);
        box-shadow: 0 0 0 3px rgba(21, 128, 61, 0.1);
    }
    
    .form-check-label {
        font-size: 14px;
        color: #555;
    }
    
    .btn-primary {
        background-color: var(--primary-color);
        color: white;
        border: none;
        border-radius: 8px;
        padding: 12px 20px;
        font-weight: 600;
        letter-spacing: 0.5px;
        width: 100%;
        transition: all 0.3s;
    }
    
    .btn-primary:hover {
        background-color: var(--primary-dark);
        transform: translateY(-1px);
    }
    
    .btn-primary:active {
        transform: translateY(0);
    }
    
    .login-footer {
        text-align: center;
        margin-top: 24px;
    }
    
    .login-footer p {
        font-size: 14px;
        color: #666;
    }
    
    .login-footer a {
        color: var(--primary-color);
        font-weight: 500;
        text-decoration: none;
    }
    
    .login-footer a:hover {
        text-decoration: underline;
    }
</style>
@endpush

@section('body_class', 'bg-primary-ultralight')

@section('content')
<div class="login-container">
    <div class="login-card">
        <div class="login-logo">
            <img src="{{ asset('images/logo.png') }}" alt="Logo">
        </div>
        <div class="login-title">
            <h1 class="text-2xl font-bold text-primary-dark">Login ke Sistem</h1>
            <p class="text-gray-600 text-sm mt-1">Masukkan kredensi untuk mengakses dashboard</p>
        </div>
        
        <div class="card-body">
            @if(session('error'))
            <div class="alert alert-danger small py-2" role="alert">
                {{ session('error') }}
            </div>
            @endif
            
            <form method="POST" action="{{ route('login.attempt') }}">
                @csrf
                
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="fas fa-envelope"></i>
                        </span>
                        <input id="email" type="email" class="form-control @error('email') is-invalid @enderror" 
                            name="email" value="{{ old('email') }}" required autocomplete="email" autofocus 
                            placeholder="Masukkan email anda">
                    </div>
                    @error('email')
                    <div class="text-danger small mt-1">{{ $message }}</div>
                    @enderror
                </div>
                
                <div class="mb-4">
                    <div class="d-flex justify-content-between align-items-center mb-1">
                        <label for="password" class="form-label">Password</label>
                    </div>
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="fas fa-lock"></i>
                        </span>
                        <input id="password" type="password" class="form-control @error('password') is-invalid @enderror" 
                            name="password" required autocomplete="current-password" 
                            placeholder="Masukkan password anda">
                    </div>
                    @error('password')
                    <div class="text-danger small mt-1">{{ $message }}</div>
                    @enderror
                </div>
                
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" name="remember" id="remember" {{ old('remember') ? 'checked' : '' }}>
                        <label class="form-check-label remember-me" for="remember">
                            Ingat saya
                        </label>
                    </div>
                </div>
                
                <div class="mb-0">
                    <button type="submit" class="btn btn-primary w-100 btn-login">
                        Masuk
                    </button>
                </div>
            </form>
            
            <div class="footer-text">
                &copy; {{ date('Y') }} Puskesmas &middot; Sistem Informasi Manajemen Puskesmas
            </div>
        </div>
    </div>
</div>
@endsection 