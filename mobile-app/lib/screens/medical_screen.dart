import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_puskesmas/models/user_model.dart';
import 'package:mobile_puskesmas/services/auth_service.dart';

class MedicalScreen extends StatefulWidget {
  final String registrationType;

  const MedicalScreen({
    Key? key,
    required this.registrationType,
  }) : super(key: key);

  @override
  State<MedicalScreen> createState() => _MedicalScreenState();
}

class _MedicalScreenState extends State<MedicalScreen> {
  final _complaintController = TextEditingController();
  bool _isLoading = true;
  UserModel? _user;
  bool _submitting = false;

  String _selectedPoli = 'POLI UMUM';
  DateTime _selectedDate = DateTime.now();
  final List<String> _doctors = [
    'Dr. John Doe',
    'Dr. Jane Smith',
    'Dr. Robert Brown'
  ];
  String? _selectedDoctor;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _complaintController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await AuthService().getUserData();
      if (user != null) {
        setState(() {
          _user = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading user data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
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
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitAppointment() async {
    if (_complaintController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan isi keluhan Anda'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedDoctor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih tenaga medis'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _submitting = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _submitting = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pendaftaran berhasil!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF06489F),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF06489F),
        elevation: 0,
        title: Text(
          'Pendaftaran ${widget.registrationType}',
          style: const TextStyle(
            fontFamily: 'KohSantepheap',
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Registration Type Banner
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: widget.registrationType == 'BPJS'
                      ? const Color(0xFFE6F3FF)
                      : const Color(0xFFF0F8FF),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: widget.registrationType == 'BPJS'
                        ? const Color(0xFF06489F).withOpacity(0.3)
                        : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.registrationType == 'BPJS'
                          ? Icons.health_and_safety
                          : Icons.local_hospital,
                      color: const Color(0xFF06489F),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pendaftaran ${widget.registrationType}',
                            style: const TextStyle(
                              fontFamily: 'KohSantepheap',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF06489F),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.registrationType == 'BPJS'
                                ? 'Menggunakan layanan BPJS Kesehatan'
                                : 'Tanpa menggunakan BPJS Kesehatan',
                            style: TextStyle(
                              fontFamily: 'KohSantepheap',
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // BPJS Information (if BPJS selected)
              if (widget.registrationType == 'BPJS') ...[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE6F3FF),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Informasi BPJS',
                          style: TextStyle(
                            fontFamily: 'KohSantepheap',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF06489F),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.credit_card,
                                size: 20, color: Colors.grey),
                            const SizedBox(width: 8),
                            const Text('No. BPJS'),
                            const Spacer(),
                            Text(
                              _user?.patientData?.noBpjs ?? 'Tidak tersedia',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 16),
                        child: Row(
                          children: [
                            const Icon(Icons.class_,
                                size: 20, color: Colors.grey),
                            const SizedBox(width: 8),
                            const Text('Kelas'),
                            const Spacer(),
                            Text(
                              _user?.patientData?.kelasRawat ??
                                  'Tidak tersedia',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Healthcare Facility Selection
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  title: const Text('S. LUMUMBA HUTAGALUNG (0000013430349)'),
                  trailing:
                      const Icon(Icons.check_circle, color: Color(0xFF06489F)),
                  onTap: () {
                    // This would open a selection dialog in a real app
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Facility Details Card
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      child: const Text(
                        'SIBORONGBORONG',
                        style: TextStyle(
                          fontFamily: 'KohSantepheap',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.home, size: 20, color: Colors.grey),
                          const SizedBox(width: 8),
                          const Text('Alamat'),
                          const Spacer(),
                          Text('JL. PINTU AIR NO. 1',
                              style: TextStyle(color: Colors.grey[700])),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16),
                      child: Row(
                        children: [
                          const Icon(Icons.phone, size: 20, color: Colors.grey),
                          const SizedBox(width: 8),
                          const Text('Telepon'),
                          const Spacer(),
                          Text('0813-61233692',
                              style: TextStyle(color: Colors.grey[700])),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Poli Selection
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  title: const Text('Pilih Poli'),
                  subtitle: Text(_selectedPoli),
                  trailing:
                      const Icon(Icons.check_circle, color: Color(0xFF06489F)),
                  onTap: () {
                    // This would open a selection dialog in a real app
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Date Selection
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  title: const Text('Pilih Tanggal Daftar'),
                  subtitle: Text(
                      'Hari ini (${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year})'),
                  trailing:
                      const Icon(Icons.check_circle, color: Color(0xFF06489F)),
                  onTap: () => _selectDate(context),
                ),
              ),
              const SizedBox(height: 20),

              // Doctor Selection
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Pilih Tenaga Medis',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  isExpanded: true,
                  hint: const Text('Pilih Tenaga Medis'),
                  value: _selectedDoctor,
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedDoctor = value;
                    });
                  },
                  items: _doctors.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Complaint Text Field
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _complaintController,
                  decoration: const InputDecoration(
                    labelText: 'Keluhan',
                    hintText: 'Silakan isi keluhan...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  maxLines: 4,
                ),
              ),
              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submitAppointment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF06489F),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: _submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Simpan',
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
    );
  }
}
