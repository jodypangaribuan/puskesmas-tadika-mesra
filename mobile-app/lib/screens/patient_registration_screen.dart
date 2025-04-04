import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_puskesmas/models/user_model.dart';
import 'package:mobile_puskesmas/services/auth_service.dart';

class PatientRegistrationScreen extends StatefulWidget {
  final Function() onRegistrationSuccess;

  const PatientRegistrationScreen({
    Key? key,
    required this.onRegistrationSuccess,
  }) : super(key: key);

  @override
  State<PatientRegistrationScreen> createState() =>
      _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState extends State<PatientRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Personal information
  final _tempatLahirController = TextEditingController();
  DateTime? _tanggalLahir;
  String _jenisKelamin = 'Laki-laki';
  final _alamatController = TextEditingController();
  String _statusPerkawinan = 'Belum Kawin';
  String _agama = 'Islam';
  final _pendidikanController = TextEditingController();

  // Additional information
  final _pekerjaanController = TextEditingController();
  final _golonganDarahController = TextEditingController();
  String _rhesus = 'Positif';
  final _tinggiBadanController = TextEditingController();
  final _beratBadanController = TextEditingController();
  final _tekananDarahController = TextEditingController();
  final _riwayatAlergiController = TextEditingController();
  final _riwayatPenyakitController = TextEditingController();

  // BPJS information
  final _noBpjsController = TextEditingController();
  String _statusBpjs = 'Aktif';
  String _kelasRawat = 'Kelas I';
  DateTime? _masaBerlakuBpjs;

  bool _isLoading = false;
  String _errorMessage = '';
  String _successMessage = '';
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await AuthService().getUserData();
      if (user != null) {
        setState(() {
          _user = user;

          // Set gender if available
          if (user.gender != null &&
              (user.gender == 'Laki-laki' || user.gender == 'Perempuan')) {
            _jenisKelamin = user.gender!;
          }

          // Set date of birth if available
          if (user.dateOfBirth != null) {
            _tanggalLahir = user.dateOfBirth;
          }
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  @override
  void dispose() {
    _tempatLahirController.dispose();
    _alamatController.dispose();
    _pendidikanController.dispose();
    _pekerjaanController.dispose();
    _golonganDarahController.dispose();
    _tinggiBadanController.dispose();
    _beratBadanController.dispose();
    _tekananDarahController.dispose();
    _riwayatAlergiController.dispose();
    _riwayatPenyakitController.dispose();
    _noBpjsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggalLahir ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF06489F),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF06489F),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _tanggalLahir = picked;
      });
    }
  }

  Future<void> _selectMasaBerlakuBPJS(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _masaBerlakuBpjs ?? DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF06489F),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF06489F),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _masaBerlakuBpjs = picked;
      });
    }
  }

  Future<void> _submitPatientRegistration() async {
    if (!_formKey.currentState!.validate()) {
      // Show a message that all fields are required
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua field harus diisi dengan benar'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_tanggalLahir == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tanggal lahir harus dipilih'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Calculate IMT if height and weight are provided
    double? imt;
    if (_tinggiBadanController.text.isNotEmpty &&
        _beratBadanController.text.isNotEmpty) {
      try {
        double tinggi = double.parse(_tinggiBadanController.text) /
            100; // convert to meters
        double berat = double.parse(_beratBadanController.text);
        imt = berat / (tinggi * tinggi);
      } catch (e) {
        // If parsing fails, leave IMT as null
      }
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _successMessage = '';
    });

    try {
      final patientData = {
        'nama': _user?.name ?? '',
        'tempat_lahir': _tempatLahirController.text,
        'tanggal_lahir': _tanggalLahir!.toIso8601String().split('T')[0],
        'jenis_kelamin': _jenisKelamin,
        'alamat': _alamatController.text,
        'no_telepon': _user?.phone ?? '',
        'pekerjaan': _pekerjaanController.text,
        'golongan_darah': _golonganDarahController.text,
        'rhesus': _rhesus,
        'status_perkawinan': _statusPerkawinan,
        'agama': _agama,
        'pendidikan': _pendidikanController.text,
        'tinggi_badan': _tinggiBadanController.text.isNotEmpty
            ? int.parse(_tinggiBadanController.text)
            : null,
        'berat_badan': _beratBadanController.text.isNotEmpty
            ? int.parse(_beratBadanController.text)
            : null,
        'imt': imt?.toStringAsFixed(2),
        'tekanan_darah': _tekananDarahController.text,
        'riwayat_alergi': _riwayatAlergiController.text,
        'riwayat_penyakit': _riwayatPenyakitController.text,
        'no_bpjs':
            _noBpjsController.text.isNotEmpty ? _noBpjsController.text : null,
        'status_bpjs': _noBpjsController.text.isNotEmpty ? _statusBpjs : null,
        'kelas_rawat': _noBpjsController.text.isNotEmpty ? _kelasRawat : null,
        'masa_berlaku_bpjs': _masaBerlakuBpjs != null
            ? _masaBerlakuBpjs!.toIso8601String().split('T')[0]
            : null,
      };

      // Print the request data for debugging
      print('Submitting patient data: ${patientData.toString()}');

      // Register as patient
      final user = await AuthService().registerAsPatient(patientData);

      // Print the response data for debugging
      print('Registration successful. Patient data:');
      if (user?.patientData != null) {
        print('Patient ID: ${user!.patientData!.id}');
        print('Patient RM: ${user.patientData!.noRm}');
        print('Patient Name: ${user.patientData!.nama}');
        // Add more fields for debugging if needed
      } else {
        print('Warning: Patient data is null in the response');
      }

      // Force refresh the user profile to ensure data is updated
      await AuthService().getProfile();

      setState(() {
        _successMessage = 'Pendaftaran pasien berhasil!';
        _isLoading = false;
      });

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Pendaftaran pasien berhasil!',
            style: TextStyle(fontFamily: 'KohSantepheap'),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

      // Callback after successful registration
      widget.onRegistrationSuccess();

      // Navigate back after a delay
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
    if (_user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF06489F),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Pendaftaran Pasien',
          style: TextStyle(
            fontFamily: 'KohSantepheap',
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Instructions
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F9FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFD1E3FF)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Iconsax.info_circle,
                            color: Color(0xFF06489F),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Informasi Pendaftaran',
                            style: TextStyle(
                              fontFamily: 'KohSantepheap',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF06489F),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Lengkapi data diri Anda dengan benar untuk mendaftar sebagai pasien di Puskesmas Siborongborong.',
                        style: TextStyle(
                          fontFamily: 'KohSantepheap',
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Error message if any
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

                // Success message if any
                if (_successMessage.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade200),
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

                // User Information Card
                Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informasi Akun',
                          style: TextStyle(
                            fontFamily: 'KohSantepheap',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF06489F),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(Iconsax.user, 'Nama',
                            _user?.name ?? 'Tidak tersedia'),
                        const Divider(),
                        _buildInfoRow(Iconsax.call, 'No. Telepon',
                            _user?.phone ?? 'Tidak tersedia'),
                        const Divider(),
                        _buildInfoRow(Iconsax.sms, 'Email',
                            _user?.email ?? 'Tidak tersedia'),
                        const Divider(),
                        _buildInfoRow(Iconsax.card, 'NIK',
                            _user?.nik ?? 'Tidak tersedia'),
                      ],
                    ),
                  ),
                ),

                // Section title
                const Text(
                  'Data Pribadi',
                  style: TextStyle(
                    fontFamily: 'KohSantepheap',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF06489F),
                  ),
                ),
                const SizedBox(height: 16),

                // Tempat Lahir field
                TextFormField(
                  controller: _tempatLahirController,
                  decoration: InputDecoration(
                    labelText: 'Tempat Lahir',
                    hintText: 'Masukkan tempat lahir',
                    prefixIcon:
                        const Icon(Iconsax.building, color: Color(0xFF06489F)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tempat lahir harus diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Tanggal Lahir field
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Tanggal Lahir',
                      prefixIcon: const Icon(Iconsax.calendar,
                          color: Color(0xFF06489F)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _tanggalLahir == null
                                ? 'Pilih tanggal lahir'
                                : '${_tanggalLahir!.day}-${_tanggalLahir!.month}-${_tanggalLahir!.year}',
                            style: TextStyle(
                              color: _tanggalLahir == null
                                  ? Colors.grey.shade600
                                  : Colors.black87,
                            ),
                          ),
                        ),
                        const Icon(Iconsax.arrow_down_1, size: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Jenis Kelamin dropdown
                DropdownButtonFormField<String>(
                  value: _jenisKelamin,
                  decoration: InputDecoration(
                    labelText: 'Jenis Kelamin',
                    prefixIcon: const Icon(Iconsax.user_octagon,
                        color: Color(0xFF06489F)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: ['Laki-laki', 'Perempuan']
                      .map((label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _jenisKelamin = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Alamat field
                TextFormField(
                  controller: _alamatController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Alamat',
                    hintText: 'Masukkan alamat lengkap',
                    prefixIcon:
                        const Icon(Iconsax.location, color: Color(0xFF06489F)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat harus diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Status Perkawinan dropdown
                DropdownButtonFormField<String>(
                  value: _statusPerkawinan,
                  decoration: InputDecoration(
                    labelText: 'Status Perkawinan',
                    prefixIcon:
                        const Icon(Iconsax.people, color: Color(0xFF06489F)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: ['Belum Kawin', 'Kawin', 'Cerai Hidup', 'Cerai Mati']
                      .map((label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _statusPerkawinan = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Agama dropdown
                DropdownButtonFormField<String>(
                  value: _agama,
                  decoration: InputDecoration(
                    labelText: 'Agama',
                    prefixIcon:
                        const Icon(Iconsax.book, color: Color(0xFF06489F)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: [
                    'Islam',
                    'Kristen',
                    'Katolik',
                    'Hindu',
                    'Buddha',
                    'Konghucu',
                    'Lainnya'
                  ]
                      .map((label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _agama = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Pendidikan Terakhir field
                TextFormField(
                  controller: _pendidikanController,
                  decoration: InputDecoration(
                    labelText: 'Pendidikan Terakhir',
                    hintText: 'Contoh: S1, SMA, dll',
                    prefixIcon:
                        const Icon(Iconsax.teacher, color: Color(0xFF06489F)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Pendidikan terakhir harus diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Riwayat Alergi field
                TextFormField(
                  controller: _riwayatAlergiController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Riwayat Alergi',
                    hintText: 'Masukkan riwayat alergi jika ada',
                    prefixIcon:
                        const Icon(Iconsax.warning_2, color: Color(0xFF06489F)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 16),

                // Riwayat Penyakit field
                TextFormField(
                  controller: _riwayatPenyakitController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Riwayat Penyakit',
                    hintText: 'Masukkan riwayat penyakit jika ada',
                    prefixIcon:
                        const Icon(Iconsax.health, color: Color(0xFF06489F)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 24),

                // Section title
                const Text(
                  'Informasi Tambahan',
                  style: TextStyle(
                    fontFamily: 'KohSantepheap',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF06489F),
                  ),
                ),
                const SizedBox(height: 16),

                // Pekerjaan field
                TextFormField(
                  controller: _pekerjaanController,
                  decoration: InputDecoration(
                    labelText: 'Pekerjaan',
                    hintText: 'Masukkan pekerjaan',
                    prefixIcon:
                        const Icon(Iconsax.briefcase, color: Color(0xFF06489F)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Pekerjaan harus diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Golongan Darah field
                TextFormField(
                  controller: _golonganDarahController,
                  decoration: InputDecoration(
                    labelText: 'Golongan Darah',
                    hintText: 'Masukkan golongan darah (A/B/AB/O)',
                    prefixIcon:
                        const Icon(Iconsax.heart, color: Color(0xFF06489F)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Golongan darah harus diisi';
                    }
                    if (!RegExp(r'^(A|B|AB|O)(\+|\-)?$', caseSensitive: false)
                        .hasMatch(value)) {
                      return 'Golongan darah tidak valid (A/B/AB/O)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Rhesus dropdown
                DropdownButtonFormField<String>(
                  value: _rhesus,
                  decoration: InputDecoration(
                    labelText: 'Rhesus',
                    prefixIcon:
                        const Icon(Iconsax.health, color: Color(0xFF06489F)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: ['Positif', 'Negatif', 'Tidak Tahu']
                      .map((label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _rhesus = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Tinggi Badan field
                TextFormField(
                  controller: _tinggiBadanController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Tinggi Badan (cm)',
                    hintText: 'Masukkan tinggi badan dalam cm',
                    prefixIcon:
                        const Icon(Iconsax.ruler, color: Color(0xFF06489F)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tinggi badan harus diisi';
                    }
                    try {
                      int height = int.parse(value);
                      if (height < 50 || height > 250) {
                        return 'Tinggi badan tidak valid (50-250 cm)';
                      }
                    } catch (e) {
                      return 'Tinggi badan harus berupa angka';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Berat Badan field
                TextFormField(
                  controller: _beratBadanController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Berat Badan (kg)',
                    hintText: 'Masukkan berat badan dalam kg',
                    prefixIcon:
                        const Icon(Iconsax.weight, color: Color(0xFF06489F)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Berat badan harus diisi';
                    }
                    try {
                      int weight = int.parse(value);
                      if (weight < 1 || weight > 300) {
                        return 'Berat badan tidak valid (1-300 kg)';
                      }
                    } catch (e) {
                      return 'Berat badan harus berupa angka';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Tekanan Darah field
                TextFormField(
                  controller: _tekananDarahController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Tekanan Darah',
                    hintText: 'Format: 120/80 mmHg',
                    prefixIcon:
                        const Icon(Iconsax.activity, color: Color(0xFF06489F)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tekanan darah harus diisi';
                    }
                    if (!RegExp(r'^\d{2,3}/\d{2,3}( mmHg)?$').hasMatch(value)) {
                      return 'Format: 120/80 atau 120/80 mmHg';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // BPJS Section title
                const Text(
                  'Informasi BPJS',
                  style: TextStyle(
                    fontFamily: 'KohSantepheap',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF06489F),
                  ),
                ),
                const SizedBox(height: 16),

                // No BPJS field
                TextFormField(
                  controller: _noBpjsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Nomor BPJS (Opsional)',
                    hintText: 'Masukkan nomor BPJS jika ada',
                    prefixIcon:
                        const Icon(Iconsax.card, color: Color(0xFF06489F)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (!RegExp(r'^\d{13}$').hasMatch(value)) {
                        return 'Nomor BPJS harus 13 digit';
                      }
                    }
                    return null;
                  },
                  onChanged: (value) {
                    // Enable/disable BPJS related fields based on whether BPJS number is provided
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16),

                // Status BPJS - only enabled if BPJS number is provided
                DropdownButtonFormField<String>(
                  value: _statusBpjs,
                  decoration: InputDecoration(
                    labelText: 'Status BPJS',
                    prefixIcon:
                        const Icon(Iconsax.status_up, color: Color(0xFF06489F)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: ['Aktif', 'Non-Aktif', 'Proses Verifikasi']
                      .map((label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ))
                      .toList(),
                  onChanged: _noBpjsController.text.isNotEmpty
                      ? (value) {
                          if (value != null) {
                            setState(() {
                              _statusBpjs = value;
                            });
                          }
                        }
                      : null,
                  validator: (value) {
                    if (_noBpjsController.text.isNotEmpty &&
                        (value == null || value.isEmpty)) {
                      return 'Status BPJS harus dipilih';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Kelas Rawat - only enabled if BPJS number is provided
                DropdownButtonFormField<String>(
                  value: _kelasRawat,
                  decoration: InputDecoration(
                    labelText: 'Kelas Rawat',
                    prefixIcon:
                        const Icon(Iconsax.hospital, color: Color(0xFF06489F)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: ['Kelas I', 'Kelas II', 'Kelas III']
                      .map((label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ))
                      .toList(),
                  onChanged: _noBpjsController.text.isNotEmpty
                      ? (value) {
                          if (value != null) {
                            setState(() {
                              _kelasRawat = value;
                            });
                          }
                        }
                      : null,
                  validator: (value) {
                    if (_noBpjsController.text.isNotEmpty &&
                        (value == null || value.isEmpty)) {
                      return 'Kelas rawat harus dipilih';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Masa Berlaku BPJS - only enabled if BPJS number is provided
                InkWell(
                  onTap: _noBpjsController.text.isNotEmpty
                      ? () => _selectMasaBerlakuBPJS(context)
                      : null,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Masa Berlaku BPJS',
                      prefixIcon: const Icon(Iconsax.calendar,
                          color: Color(0xFF06489F)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _masaBerlakuBpjs == null
                                ? 'Pilih masa berlaku'
                                : '${_masaBerlakuBpjs!.day}-${_masaBerlakuBpjs!.month}-${_masaBerlakuBpjs!.year}',
                            style: TextStyle(
                              color: _masaBerlakuBpjs == null
                                  ? Colors.grey.shade600
                                  : Colors.black87,
                            ),
                          ),
                        ),
                        const Icon(Iconsax.arrow_down_1, size: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitPatientRegistration,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF06489F),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Daftar sebagai Pasien',
                            style: TextStyle(
                              fontFamily: 'KohSantepheap',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build info row for user card
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF06489F)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'KohSantepheap',
                  color: Colors.grey.shade700,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'KohSantepheap',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
