import 'package:flutter/material.dart';
import 'package:mobile_puskesmas/services/auth_service.dart';
import 'package:iconsax/iconsax.dart';

class RegisterScreen extends StatefulWidget {
  final Function() onRegisterSuccess;

  const RegisterScreen({Key? key, required this.onRegisterSuccess})
      : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nikController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String _errorMessage = '';
  String _successMessage = '';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _phoneController.dispose();
    _nikController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _successMessage = '';
    });

    try {
      await AuthService().register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
        _passwordConfirmController.text,
        _phoneController.text,
        _nikController.text,
      );

      setState(() {
        _successMessage = 'Registrasi berhasil! Silahkan masuk ke akun Anda.';
        _isLoading = false;
      });

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Registrasi berhasil!',
            style: TextStyle(fontFamily: 'KohSantepheap'),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

      // Navigate back to login screen after delay
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06489F),
      body: SafeArea(
        bottom: false,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF06489F),
                const Color(0xFF06489F).withOpacity(0.8),
                Colors.white,
              ],
              stops: const [0.0, 0.3, 0.6],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App Logo
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 60,
                      height: 60,
                    ),
                  ),

                  // Registration Form Container
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          spreadRadius: 5,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Header
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Daftar Akun',
                                  style: TextStyle(
                                    fontFamily: 'KohSantepheap',
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF06489F),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Buat akun untuk menggunakan aplikasi',
                                  style: TextStyle(
                                    fontFamily: 'KohSantepheap',
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (_errorMessage.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Iconsax.warning_2,
                                    color: Colors.red.shade700,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      _errorMessage,
                                      style: TextStyle(
                                        fontFamily: 'KohSantepheap',
                                        color: Colors.red.shade700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          if (_successMessage.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: Colors.green.shade200),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Iconsax.tick_circle,
                                    color: Colors.green.shade700,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      _successMessage,
                                      style: TextStyle(
                                        fontFamily: 'KohSantepheap',
                                        color: Colors.green.shade700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // Name Field
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: TextFormField(
                              controller: _nameController,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: 'Nama Lengkap',
                                hintText: 'Masukkan nama lengkap Anda',
                                prefixIcon: Icon(
                                  Iconsax.user,
                                  color: Color(0xFF06489F),
                                  size: 22,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Color(0xFF06489F),
                                    width: 1.5,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                  fontFamily: 'KohSantepheap',
                                ),
                                hintStyle: TextStyle(
                                  fontFamily: 'KohSantepheap',
                                  fontSize: 14,
                                ),
                              ),
                              style: TextStyle(
                                fontFamily: 'KohSantepheap',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Nama tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                          ),

                          // Email Field
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'Masukkan email Anda',
                                prefixIcon: Icon(
                                  Iconsax.sms,
                                  color: Color(0xFF06489F),
                                  size: 22,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Color(0xFF06489F),
                                    width: 1.5,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                  fontFamily: 'KohSantepheap',
                                ),
                                hintStyle: TextStyle(
                                  fontFamily: 'KohSantepheap',
                                  fontSize: 14,
                                ),
                              ),
                              style: TextStyle(
                                fontFamily: 'KohSantepheap',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email tidak boleh kosong';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value)) {
                                  return 'Email tidak valid';
                                }
                                return null;
                              },
                            ),
                          ),

                          // Phone Field
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'Nomor Telepon',
                                hintText: 'Masukkan nomor telepon Anda',
                                prefixIcon: Icon(
                                  Iconsax.call,
                                  color: Color(0xFF06489F),
                                  size: 22,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Color(0xFF06489F),
                                    width: 1.5,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                  fontFamily: 'KohSantepheap',
                                ),
                                hintStyle: TextStyle(
                                  fontFamily: 'KohSantepheap',
                                  fontSize: 14,
                                ),
                              ),
                              style: TextStyle(
                                fontFamily: 'KohSantepheap',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Nomor telepon tidak boleh kosong';
                                }
                                if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
                                  return 'Nomor telepon tidak valid';
                                }
                                return null;
                              },
                            ),
                          ),

                          // NIK Field
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: TextFormField(
                              controller: _nikController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'NIK',
                                hintText: 'Masukkan NIK Anda',
                                prefixIcon: Icon(
                                  Iconsax.card,
                                  color: Color(0xFF06489F),
                                  size: 22,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Color(0xFF06489F),
                                    width: 1.5,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                  fontFamily: 'KohSantepheap',
                                ),
                                hintStyle: TextStyle(
                                  fontFamily: 'KohSantepheap',
                                  fontSize: 14,
                                ),
                              ),
                              style: TextStyle(
                                fontFamily: 'KohSantepheap',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'NIK tidak boleh kosong';
                                }
                                if (value.length != 16) {
                                  return 'NIK harus 16 digit';
                                }
                                return null;
                              },
                            ),
                          ),

                          // Password Field
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Masukkan password',
                                prefixIcon: Icon(
                                  Iconsax.lock,
                                  color: Color(0xFF06489F),
                                  size: 22,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Iconsax.eye_slash
                                        : Iconsax.eye,
                                    color: Color(0xFF06489F),
                                    size: 22,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Color(0xFF06489F),
                                    width: 1.5,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                  fontFamily: 'KohSantepheap',
                                ),
                                hintStyle: TextStyle(
                                  fontFamily: 'KohSantepheap',
                                  fontSize: 14,
                                ),
                              ),
                              style: TextStyle(
                                fontFamily: 'KohSantepheap',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password tidak boleh kosong';
                                }
                                if (value.length < 8) {
                                  return 'Password minimal 8 karakter';
                                }
                                return null;
                              },
                            ),
                          ),

                          // Confirm Password Field
                          Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            child: TextFormField(
                              controller: _passwordConfirmController,
                              obscureText: !_isConfirmPasswordVisible,
                              decoration: InputDecoration(
                                labelText: 'Konfirmasi Password',
                                hintText: 'Masukkan ulang password',
                                prefixIcon: Icon(
                                  Iconsax.lock,
                                  color: Color(0xFF06489F),
                                  size: 22,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isConfirmPasswordVisible
                                        ? Iconsax.eye_slash
                                        : Iconsax.eye,
                                    color: Color(0xFF06489F),
                                    size: 22,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isConfirmPasswordVisible =
                                          !_isConfirmPasswordVisible;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Color(0xFF06489F),
                                    width: 1.5,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                  fontFamily: 'KohSantepheap',
                                ),
                                hintStyle: TextStyle(
                                  fontFamily: 'KohSantepheap',
                                  fontSize: 14,
                                ),
                              ),
                              style: TextStyle(
                                fontFamily: 'KohSantepheap',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Konfirmasi password tidak boleh kosong';
                                }
                                if (value != _passwordController.text) {
                                  return 'Password tidak cocok';
                                }
                                return null;
                              },
                            ),
                          ),

                          // Register Button
                          ElevatedButton(
                            onPressed: _isLoading ? null : _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF06489F),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Iconsax.user_add,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Daftar',
                                        style: TextStyle(
                                          fontFamily: 'KohSantepheap',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          SizedBox(height: 20),

                          // Login Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Sudah punya akun?',
                                style: TextStyle(
                                  fontFamily: 'KohSantepheap',
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Iconsax.login,
                                      color: Color(0xFF06489F),
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Login',
                                      style: TextStyle(
                                        fontFamily: 'KohSantepheap',
                                        color: Color(0xFF06489F),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
