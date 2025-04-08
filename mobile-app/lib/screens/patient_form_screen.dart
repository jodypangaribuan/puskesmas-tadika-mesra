import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_puskesmas/services/auth_service.dart';

class PatientFormScreen extends StatefulWidget {
  const PatientFormScreen({Key? key}) : super(key: key);

  @override
  State<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends State<PatientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tanggalLahirController = TextEditingController();
  final _golonganDarahController = TextEditingController();
  final _pekerjaanController = TextEditingController();
  final _beratBadanController = TextEditingController();
  final _tinggiBadanController = TextEditingController();
  final _alergiController = TextEditingController();
  final _riwayatPenyakitController = TextEditingController();
  final _complaintController = TextEditingController();
  final _dateController = TextEditingController();
  final _alamatController = TextEditingController();

  // Maps to track if field is filled
  final Map<String, bool> _fieldFilled = {};

  bool _isLoading = false;
  DateTime? _selectedDate;
  DateTime? _selectedBirthDate;
  String? _gender;
  String? _bloodType;
  String? _occupation;
  String? _cluster;
  bool _isOtherBloodType = false;
  bool _isOtherOccupation = false;

  // Opsi-opsi dropdown
  final List<String> _genderOptions = ['Laki-laki', 'Perempuan'];
  final List<String> _bloodTypeOptions = ['A', 'B', 'AB', 'O', 'Lainnya'];
  final List<String> _occupationOptions = [
    'Pegawai Swasta',
    'Pegawai Negeri',
    'Wiraswasta',
    'Pelajar/Mahasiswa',
    'Ibu Rumah Tangga',
    'Petani',
    'Buruh',
    'Pensiunan',
    'Tidak Bekerja',
    'Lainnya'
  ];
  final List<Map<String, String>> _clusterOptions = [
    {'value': 'Klaster I', 'desc': 'Klaster Manajemen'},
    {'value': 'Klaster II', 'desc': 'Klaster Ibu dan Anak'},
    {'value': 'Klaster III', 'desc': 'Usia Dewasa dan Lansia'},
    {'value': 'Klaster IV', 'desc': 'Penanggulangan Penyakit Menular'}
  ];

  // Data user yang sedang login
  String? _userNik;
  String? _userEmail;
  String? _userName;
  String? _userPhone;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _setupTextFieldListeners();
  }

  void _setupTextFieldListeners() {
    _tanggalLahirController.addListener(() => _updateFieldStatus(
        'tanggalLahir', _tanggalLahirController.text.isNotEmpty));
    _golonganDarahController.addListener(() => _updateFieldStatus(
        'golonganDarah', _golonganDarahController.text.isNotEmpty));
    _pekerjaanController.addListener(() =>
        _updateFieldStatus('pekerjaan', _pekerjaanController.text.isNotEmpty));
    _beratBadanController.addListener(() => _updateFieldStatus(
        'beratBadan', _beratBadanController.text.isNotEmpty));
    _tinggiBadanController.addListener(() => _updateFieldStatus(
        'tinggiBadan', _tinggiBadanController.text.isNotEmpty));
    _alergiController.addListener(
        () => _updateFieldStatus('alergi', _alergiController.text.isNotEmpty));
    _riwayatPenyakitController.addListener(() => _updateFieldStatus(
        'riwayatPenyakit', _riwayatPenyakitController.text.isNotEmpty));
    _complaintController.addListener(() =>
        _updateFieldStatus('complaint', _complaintController.text.isNotEmpty));
    _alamatController.addListener(
        () => _updateFieldStatus('alamat', _alamatController.text.isNotEmpty));
  }

  void _updateFieldStatus(String fieldName, bool isFilled) {
    setState(() {
      _fieldFilled[fieldName] = isFilled;
    });
  }

  Future<void> _loadUserData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final user = await AuthService().getUserData();
      if (user != null) {
        setState(() {
          _userNik = user.nik;
          _userEmail = user.email;
          _userName = user.name;
          _userPhone = user.phone;

          if (user.gender != null && _genderOptions.contains(user.gender)) {
            _gender = user.gender!;
          }
        });
      }
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _alamatController.dispose();
    _tanggalLahirController.dispose();
    _golonganDarahController.dispose();
    _pekerjaanController.dispose();
    _beratBadanController.dispose();
    _tinggiBadanController.dispose();
    _alergiController.dispose();
    _riwayatPenyakitController.dispose();
    _complaintController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime(2000),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF06489F),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
        _tanggalLahirController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF06489F),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      // Tampilkan pesan sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pendaftaran berhasil!'),
          backgroundColor: Colors.green,
        ),
      );

      // Kembali ke halaman sebelumnya
      Navigator.pop(context);
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF06489F),
        elevation: 0,
        title: const Text(
          'Pendaftaran Pasien',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'KohSantepheap',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF06489F)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Profile Card
                    _buildUserProfileCard(),

                    const SizedBox(height: 24),

                    // Data Identitas Pasien
                    _buildSectionTitle('Data Identitas Pasien',
                        'Lengkapi informasi data diri Anda'),

                    _buildDropdownField(
                      label: 'Jenis Kelamin',
                      value: _gender,
                      hint: 'Pilih jenis kelamin',
                      items: _genderOptions.map((item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _gender = value;
                          });
                        }
                      },
                      icon: Iconsax.woman,
                    ),

                    _buildDateField(
                      controller: _tanggalLahirController,
                      label: 'Tanggal Lahir',
                      hint: 'DD/MM/YYYY',
                      icon: Iconsax.calendar,
                      onTap: () => _selectBirthDate(context),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tanggal lahir tidak boleh kosong';
                        }
                        return null;
                      },
                      fieldName: 'tanggalLahir',
                    ),

                    _buildDropdownWithOther(
                      label: 'Pekerjaan',
                      value: _occupation,
                      hint: 'Pilih pekerjaan',
                      items: _occupationOptions,
                      isOther: _isOtherOccupation,
                      otherController: _pekerjaanController,
                      icon: Iconsax.briefcase,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _occupation = value;
                            _isOtherOccupation = value == 'Lainnya';
                          });
                        }
                      },
                      otherHint: 'Masukkan pekerjaan lain',
                      validator: (value) {
                        if (_isOtherOccupation &&
                            (value == null || value.isEmpty)) {
                          return 'Pekerjaan tidak boleh kosong';
                        }
                        return null;
                      },
                      otherFieldName: 'pekerjaan',
                    ),

                    _buildTextField(
                      controller: _alamatController,
                      label: 'Alamat',
                      hint: 'Masukkan alamat lengkap',
                      icon: Iconsax.location,
                      maxLines: null,
                      minHeight: 100,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Alamat tidak boleh kosong';
                        }
                        return null;
                      },
                      fieldName: 'alamat',
                    ),

                    const SizedBox(height: 24),

                    // Data Medis Pasien
                    _buildSectionTitle('Data Medis Pasien',
                        'Lengkapi informasi kesehatan Anda'),

                    _buildClusterDropdown(
                      label: 'Klaster',
                      value: _cluster,
                      hint: 'Pilih klaster',
                      items: _clusterOptions,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _cluster = value;
                          });
                        }
                      },
                      icon: Iconsax.category,
                    ),

                    _buildDropdownWithOther(
                      label: 'Golongan Darah',
                      value: _bloodType,
                      hint: 'Pilih golongan darah',
                      items: _bloodTypeOptions,
                      isOther: _isOtherBloodType,
                      otherController: _golonganDarahController,
                      icon: Iconsax.heart,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _bloodType = value;
                            _isOtherBloodType = value == 'Lainnya';
                          });
                        }
                      },
                      otherHint: 'Masukkan golongan darah lain',
                      otherFieldName: 'golonganDarah',
                    ),

                    // Two columns layout for weight and height
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _beratBadanController,
                            label: 'Berat Badan (kg)',
                            hint: 'Contoh: 65',
                            icon: Iconsax.weight,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Berat badan tidak boleh kosong';
                              }
                              return null;
                            },
                            fieldName: 'beratBadan',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildTextField(
                            controller: _tinggiBadanController,
                            label: 'Tinggi Badan (cm)',
                            hint: 'Contoh: 170',
                            icon: Iconsax.ruler,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Tinggi badan tidak boleh kosong';
                              }
                              return null;
                            },
                            fieldName: 'tinggiBadan',
                          ),
                        ),
                      ],
                    ),

                    _buildTextField(
                      controller: _alergiController,
                      label: 'Alergi',
                      hint: 'Masukkan alergi (jika ada)',
                      icon: Iconsax.danger,
                      maxLines: null,
                      minHeight: 100,
                      fieldName: 'alergi',
                    ),

                    _buildTextField(
                      controller: _riwayatPenyakitController,
                      label: 'Riwayat Penyakit',
                      hint: 'Masukkan riwayat penyakit (jika ada)',
                      icon: Iconsax.health,
                      maxLines: null,
                      minHeight: 100,
                      fieldName: 'riwayatPenyakit',
                    ),

                    _buildTextField(
                      controller: _complaintController,
                      label: 'Keluhan',
                      hint: 'Deskripsikan keluhan Anda',
                      icon: Iconsax.clipboard_text,
                      maxLines: null,
                      minHeight: 100,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Keluhan tidak boleh kosong';
                        }
                        return null;
                      },
                      fieldName: 'complaint',
                    ),

                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF06489F),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Iconsax.tick_circle,
                                      size: 20, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text(
                                    'DAFTAR PASIEN',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'KohSantepheap',
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildUserProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: const Color(0xFF06489F).withOpacity(0.1)),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Color(0xFFEDF5FF),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF5FF),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF06489F), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF06489F).withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Iconsax.user,
                    color: Color(0xFF06489F),
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userName ?? 'Nama Pengguna',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF06489F),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Iconsax.message,
                            size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            _userEmail ?? 'email@example.com',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Iconsax.card, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 5),
                        Text(
                          'NIK: ${_userNik ?? '-'}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF06489F),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF06489F).withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.hospital,
                  size: 16,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                Text(
                  'Pendaftaran Pasien FKTP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF06489F),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF06489F),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int? maxLines = 1,
    double? minHeight,
    String? Function(String?)? validator,
    String? fieldName,
  }) {
    bool isFilled = fieldName != null
        ? _fieldFilled[fieldName] ?? false
        : controller.text.isNotEmpty;

    // Menentukan padding berdasarkan jenis field
    EdgeInsetsGeometry textFieldPadding;
    if (maxLines == 1 || maxLines == null) {
      textFieldPadding =
          const EdgeInsets.symmetric(vertical: 15, horizontal: 15);
    } else {
      textFieldPadding =
          const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 50);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                constraints: minHeight != null
                    ? BoxConstraints(minHeight: minHeight > 60 ? 60 : minHeight)
                    : null,
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle:
                        TextStyle(color: Colors.grey.shade400, fontSize: 13),
                    prefixIcon:
                        Icon(icon, color: const Color(0xFF06489F), size: 20),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: textFieldPadding,
                    suffixIcon: isFilled ? null : const SizedBox(width: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF06489F)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.red.shade300),
                    ),
                    alignLabelWithHint: true,
                    isCollapsed: false,
                  ),
                  style: const TextStyle(fontSize: 13),
                  keyboardType: keyboardType,
                  maxLines: maxLines,
                  minLines: minHeight != null ? 3 : 1,
                  textAlignVertical: TextAlignVertical.top,
                  validator: validator,
                  onChanged: (value) {
                    if (fieldName != null) {
                      _updateFieldStatus(fieldName, value.isNotEmpty);
                    }
                  },
                ),
              ),
              if (isFilled)
                Positioned(
                  right: 12,
                  top: null, // Menghapus top constraint agar centered
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFF06489F),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Function() onTap,
    String? Function(String?)? validator,
    String? fieldName,
  }) {
    bool isFilled = fieldName != null
        ? _fieldFilled[fieldName] ?? false
        : controller.text.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle:
                      TextStyle(color: Colors.grey.shade400, fontSize: 13),
                  prefixIcon:
                      Icon(icon, color: const Color(0xFF06489F), size: 20),
                  suffixIcon: isFilled
                      ? null
                      : const Padding(
                          padding: EdgeInsets.only(right: 0),
                          child: Icon(
                            Icons.calendar_month_rounded,
                            color: Color(0xFF06489F),
                            size: 20,
                          ),
                        ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF06489F)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.red.shade300),
                  ),
                ),
                style: const TextStyle(fontSize: 13),
                readOnly: true,
                onTap: () {
                  onTap();
                  if (fieldName != null) {
                    Future.delayed(const Duration(milliseconds: 300), () {
                      _updateFieldStatus(fieldName, controller.text.isNotEmpty);
                    });
                  }
                },
                validator: validator,
              ),
              if (isFilled)
                Positioned(
                  right: 12,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFF06489F),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
    required IconData icon,
    String? hint,
  }) {
    // Dropdown is filled if a value is selected
    bool isFilled = value != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(icon, color: const Color(0xFF06489F), size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            dropdownMenuTheme: DropdownMenuThemeData(
                              inputDecorationTheme: InputDecorationTheme(
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          child: DropdownButton<String>(
                            value: value,
                            hint: Text(
                              hint ?? 'Pilih $label',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 13,
                              ),
                            ),
                            items: items,
                            onChanged: onChanged,
                            isExpanded: true,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                            alignment: Alignment.centerLeft,
                            icon: isFilled
                                ? const SizedBox.shrink()
                                : Container(
                                    margin: const EdgeInsets.only(right: 0),
                                    child: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Color(0xFF06489F),
                                      size: 22,
                                    ),
                                  ),
                            menuMaxHeight: 300,
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            elevation: 4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isFilled)
                Positioned(
                  right: 12,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFF06489F),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownWithOther({
    required String label,
    required String? value,
    required List<String> items,
    required bool isOther,
    required TextEditingController otherController,
    required IconData icon,
    required Function(String?) onChanged,
    required String otherHint,
    String? Function(String?)? validator,
    String? otherFieldName,
    String? hint,
  }) {
    // Dropdown is filled if a value is selected
    bool isFilled = value != null;
    bool isOtherFilled = isOther
        ? (otherFieldName != null
            ? _fieldFilled[otherFieldName] ?? false
            : otherController.text.isNotEmpty)
        : false;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(icon, color: const Color(0xFF06489F), size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            dropdownMenuTheme: DropdownMenuThemeData(
                              inputDecorationTheme: InputDecorationTheme(
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          child: DropdownButton<String>(
                            value: value,
                            hint: Text(
                              hint ?? 'Pilih $label',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 13,
                              ),
                            ),
                            items: items.map((item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: onChanged,
                            isExpanded: true,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                            alignment: Alignment.centerLeft,
                            icon: (isFilled || isOtherFilled)
                                ? const SizedBox.shrink()
                                : Container(
                                    margin: const EdgeInsets.only(right: 0),
                                    child: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Color(0xFF06489F),
                                      size: 22,
                                    ),
                                  ),
                            menuMaxHeight: 300,
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            elevation: 4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isFilled || isOtherFilled)
                Positioned(
                  right: 12,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFF06489F),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (isOther) ...[
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(top: 10),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  TextFormField(
                    controller: otherController,
                    decoration: InputDecoration(
                      hintText: otherHint,
                      hintStyle:
                          TextStyle(color: Colors.grey.shade400, fontSize: 13),
                      prefixIcon:
                          Icon(icon, color: const Color(0xFF06489F), size: 20),
                      suffixIcon:
                          isOtherFilled ? null : const SizedBox(width: 20),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF06489F)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.red.shade300),
                      ),
                    ),
                    style: const TextStyle(fontSize: 13),
                    validator: validator,
                    onChanged: (value) {
                      if (otherFieldName != null) {
                        _updateFieldStatus(otherFieldName, value.isNotEmpty);
                      }
                    },
                  ),
                  if (isOtherFilled)
                    Positioned(
                      right: 12,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Color(0xFF06489F),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildClusterDropdown({
    required String label,
    required String? value,
    required String hint,
    required List<Map<String, String>> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    // Dropdown is filled if a value is selected
    bool isFilled = value != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  _showClusterInfoDialog(context);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.help_outline,
                      size: 16,
                      color: const Color(0xFF06489F).withOpacity(0.8),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Lihat detail",
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFF06489F).withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(icon, color: const Color(0xFF06489F), size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            dropdownMenuTheme: DropdownMenuThemeData(
                              inputDecorationTheme: InputDecorationTheme(
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          child: DropdownButton<String>(
                            value: value,
                            hint: Text(
                              hint,
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 13,
                              ),
                            ),
                            items: items.map((item) {
                              return DropdownMenuItem<String>(
                                value: item['value'],
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          item['value']!,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          item['desc']!,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey.shade600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: onChanged,
                            isExpanded: true,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                            alignment: Alignment.centerLeft,
                            icon: isFilled
                                ? const SizedBox.shrink()
                                : Container(
                                    margin: const EdgeInsets.only(right: 0),
                                    child: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Color(0xFF06489F),
                                      size: 22,
                                    ),
                                  ),
                            menuMaxHeight: 300,
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            elevation: 4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isFilled)
                Positioned(
                  right: 12,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFF06489F),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showClusterInfoDialog(BuildContext context) {
    final double dialogWidth = MediaQuery.of(context).size.width * 0.9;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          width: dialogWidth,
          constraints: BoxConstraints(
            maxWidth: 450,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF06489F).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.info_outline,
                        color: Color(0xFF06489F),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Informasi Klaster',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF06489F),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.black54,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Berikut ini penjelasan mengenai jenis klaster pada FKTP:',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                _buildClusterInfoItem(
                  title: 'Klaster I - Klaster Manajemen',
                  description:
                      'Klaster untuk pengelolaan dan administrasi puskesmas, termasuk pendaftaran pasien, pengelolaan data, dan layanan dasar.',
                  icon: Icons.admin_panel_settings,
                ),
                const SizedBox(height: 12),
                _buildClusterInfoItem(
                  title: 'Klaster II - Klaster Ibu dan Anak',
                  description:
                      'Klaster untuk layanan kesehatan ibu dan anak, termasuk kesehatan reproduksi, imunisasi, pemeriksaan anak, dan konsultasi KB.',
                  icon: Icons.child_care,
                ),
                const SizedBox(height: 12),
                _buildClusterInfoItem(
                  title: 'Klaster III - Usia Dewasa dan Lansia',
                  description:
                      'Klaster untuk pelayanan kesehatan bagi pasien dewasa dan lansia, termasuk penanganan penyakit degeneratif dan perawatan geriatri.',
                  icon: Icons.elderly,
                ),
                const SizedBox(height: 12),
                _buildClusterInfoItem(
                  title: 'Klaster IV - Penanggulangan Penyakit Menular',
                  description:
                      'Klaster untuk penanganan dan pencegahan penyakit menular, termasuk TB, DBD, HIV/AIDS, dan penyakit-penyakit infeksi lainnya.',
                  icon: Icons.coronavirus,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF06489F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Mengerti',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
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

  Widget _buildClusterInfoItem({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF06489F).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFF06489F),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF06489F),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
