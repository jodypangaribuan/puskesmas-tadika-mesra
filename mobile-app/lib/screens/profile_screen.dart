import 'package:flutter/material.dart';
import 'package:mobile_puskesmas/models/user_model.dart';
import 'package:mobile_puskesmas/screens/auth/login_screen.dart';
import 'package:mobile_puskesmas/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  bool _isRefreshing = false;
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData(forceRefresh: true);
  }

  Future<void> _loadUserData({bool forceRefresh = false}) async {
    if (mounted) {
      setState(() {
        _isLoading = !_isRefreshing;
        _isRefreshing = forceRefresh;
      });
    }

    try {
      UserModel? user;

      // If forceRefresh is true, get profile from server first
      if (forceRefresh) {
        print('Force refreshing profile data from server');
        try {
          user = await AuthService().getProfile();
          print('Profile refreshed successfully from server');
        } catch (e) {
          print('Error refreshing profile from server: $e');
          // If server refresh fails, try to load from local storage
          user = await AuthService().getUserData();
        }
      } else {
        // Just load from local storage
        user = await AuthService().getUserData();
      }

      if (mounted) {
        setState(() {
          _user = user;
          _isLoading = false;
          _isRefreshing = false;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isRefreshing = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Konfirmasi Keluar',
          style: TextStyle(
            fontFamily: 'KohSantepheap',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari akun ini?',
          style: TextStyle(
            fontFamily: 'KohSantepheap',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Batal',
              style: TextStyle(
                fontFamily: 'KohSantepheap',
                color: Colors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() {
                _isLoading = true;
              });
              await AuthService().logout();
              if (mounted) {
                setState(() {
                  _user = null;
                  _isLoading = false;
                });
              }
            },
            child: const Text(
              'Ya, Keluar',
              style: TextStyle(
                fontFamily: 'KohSantepheap',
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onLoginSuccess() {
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF06489F),
          ),
        ),
      );
    }

    // If user is not logged in, show login screen
    if (_user == null) {
      return LoginScreen(onLoginSuccess: _onLoginSuccess);
    }

    // User is logged in, show profile data
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF06489F),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Data Pasien',
          style: TextStyle(
            fontFamily: 'KohSantepheap',
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        actions: [
          // Add refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed:
                _isRefreshing ? null : () => _loadUserData(forceRefresh: true),
            tooltip: 'Refresh data',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _loadUserData(forceRefresh: true),
        color: const Color(0xFF06489F),
        child: Column(
          children: [
            _buildProfileHeader(),
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                children: [
                  _isRefreshing
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Memperbarui data...',
                              style: TextStyle(
                                fontFamily: 'KohSantepheap',
                                fontSize: 14,
                                color: Color(0xFF06489F),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  _buildNIKSection(context),
                  const SizedBox(height: 20),
                  _buildPersonalDataSection(context),
                  const SizedBox(height: 20),
                  _buildMedicalDataSection(context),
                  const SizedBox(height: 20),
                  _buildHealthFacilitiesSection(context),
                  const SizedBox(height: 20),
                  _buildButtonsSection(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF06489F),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 15),
          Row(
            children: [
              const SizedBox(width: 20),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Color(0xFF06489F),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _user?.patientData?.nama?.toUpperCase() ??
                          _user?.name?.toUpperCase() ??
                          'NAMA PENGGUNA',
                      style: const TextStyle(
                        fontFamily: 'KohSantepheap',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        'NO. RM: ${_user?.patientData?.noRm ?? '-'}',
                        style: const TextStyle(
                          fontFamily: 'KohSantepheap',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF06489F),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNIKSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Data NIK',
            style: TextStyle(
              fontFamily: 'KohSantepheap',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF06489F),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.badge_outlined,
                  color: Color(0xFF06489F),
                  size: 30,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nomor Induk Kependudukan (NIK)',
                      style: TextStyle(
                        fontFamily: 'KohSantepheap',
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _user?.nik ?? '-',
                      style: const TextStyle(
                        fontFamily: 'KohSantepheap',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalDataSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Data Pribadi',
            style: TextStyle(
              fontFamily: 'KohSantepheap',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF06489F),
            ),
          ),
          const SizedBox(height: 15),
          _buildDataItem('Tempat, Tanggal Lahir',
              '${_user?.patientData?.tempatLahir ?? '-'}, ${_user?.patientData?.getFormattedTanggalLahir() ?? _user?.getFormattedDateOfBirth() ?? '-'}'),
          _buildDataItem('Jenis Kelamin',
              _user?.patientData?.jenisKelamin ?? _user?.gender ?? '-'),
          _buildDataItem('Alamat', _user?.patientData?.alamat ?? '-'),
          _buildDataItem('No. Telepon',
              _user?.patientData?.noTelepon ?? _user?.phone ?? '-'),
          _buildDataItem('Email', _user?.email ?? '-'),
          _buildDataItem('Status Perkawinan',
              _user?.patientData?.statusPerkawinan ?? 'Belum diisi'),
          _buildDataItem('Agama', _user?.patientData?.agama ?? 'Belum diisi'),
          _buildDataItem('Pekerjaan', _user?.patientData?.pekerjaan ?? '-'),
          _buildDataItem('Pendidikan Terakhir',
              _user?.patientData?.pendidikan ?? 'Belum diisi'),
        ],
      ),
    );
  }

  Widget _buildMedicalDataSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Data Kesehatan',
            style: TextStyle(
              fontFamily: 'KohSantepheap',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF06489F),
            ),
          ),
          const SizedBox(height: 15),
          _buildDataItem('Golongan Darah',
              _user?.patientData?.golonganDarah ?? 'Belum diisi'),
          _buildDataItem('Rhesus', _user?.patientData?.rhesus ?? 'Belum diisi'),
          _buildDataItem(
              'Tinggi Badan',
              _user?.patientData?.tinggiBadan != null
                  ? '${_user?.patientData?.tinggiBadan} cm'
                  : 'Belum diisi'),
          _buildDataItem(
              'Berat Badan',
              _user?.patientData?.beratBadan != null
                  ? '${_user?.patientData?.beratBadan} kg'
                  : 'Belum diisi'),
          _buildDataItem('IMT', _user?.patientData?.imt ?? 'Belum diisi'),
          _buildDataItem('Tekanan Darah',
              _user?.patientData?.tekananDarah ?? 'Belum diisi'),
          _buildDataItem('Disabilitas', 'Tidak Ada'),
          _buildDataItem('Riwayat Alergi',
              _user?.patientData?.riwayatAlergi ?? 'Tidak Ada'),
          _buildDataItem('Riwayat Penyakit',
              _user?.patientData?.riwayatPenyakit ?? 'Tidak Ada'),
        ],
      ),
    );
  }

  Widget _buildHealthFacilitiesSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fasilitas Kesehatan',
            style: TextStyle(
              fontFamily: 'KohSantepheap',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF06489F),
            ),
          ),
          const SizedBox(height: 15),
          _buildDataItem('FASKES Tingkat 1', 'Puskesmas Siborongborong'),
          _buildDataItem('No. BPJS Kesehatan',
              _user?.patientData?.noBpjs ?? 'Belum diisi'),
          _buildDataItem('Status Kepesertaan',
              _user?.patientData?.statusBpjs ?? 'Belum diisi'),
          _buildDataItem(
              'Kelas Rawat', _user?.patientData?.kelasRawat ?? 'Belum diisi'),
          _buildDataItem('Masa Berlaku',
              _user?.patientData?.masaBerlakuBpjs ?? 'Belum diisi'),
        ],
      ),
    );
  }

  Widget _buildButtonsSection(BuildContext context) {
    return Column(
      children: [
        _buildActionButton(
          icon: Icons.history,
          title: 'Riwayat Kunjungan',
          onTap: () {
            // TODO: Navigate to history page
          },
        ),
        const SizedBox(height: 10),
        _buildActionButton(
          icon: Icons.medication,
          title: 'Riwayat Pengobatan',
          onTap: () {
            // TODO: Navigate to medication history
          },
        ),
        const SizedBox(height: 10),
        _buildActionButton(
          icon: Icons.edit_outlined,
          title: 'Ubah Data Profil',
          onTap: () {
            // TODO: Navigate to edit profile
          },
        ),
        const SizedBox(height: 10),
        _buildActionButton(
          icon: Icons.settings,
          title: 'Konfigurasi Server',
          onTap: () {
            _showServerConfigDialog(context);
          },
        ),
        const SizedBox(height: 20),
        _buildLogoutButton(context),
      ],
    );
  }

  void _showServerConfigDialog(BuildContext context) {
    final serverUrlController =
        TextEditingController(text: AuthService.baseUrl);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Konfigurasi Server',
          style: TextStyle(
            fontFamily: 'KohSantepheap',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Masukkan URL API server:',
              style: TextStyle(
                fontFamily: 'KohSantepheap',
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: serverUrlController,
              decoration: InputDecoration(
                labelText: 'URL API',
                hintText: 'https://example.com/api',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Batal',
              style: TextStyle(
                fontFamily: 'KohSantepheap',
                color: Colors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final newUrl = serverUrlController.text.trim();
              if (newUrl.isNotEmpty) {
                AuthService.updateBaseUrl(newUrl);

                Navigator.pop(context);

                // Confirm the change
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'URL server diperbarui: $newUrl',
                      style: const TextStyle(fontFamily: 'KohSantepheap'),
                    ),
                    duration: const Duration(seconds: 3),
                  ),
                );

                // Reload user data to verify the connection
                await _loadUserData(forceRefresh: true);
              }
            },
            child: const Text(
              'Simpan',
              style: TextStyle(
                fontFamily: 'KohSantepheap',
                color: Color(0xFF06489F),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataItem(String label, String value) {
    final textGreyColor = Colors.grey.shade700;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'KohSantepheap',
                fontSize: 13,
                color: textGreyColor,
              ),
            ),
          ),
          Text(
            ': ',
            style: TextStyle(
              fontFamily: 'KohSantepheap',
              fontSize: 13,
              color: textGreyColor,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'KohSantepheap',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF06489F),
              size: 22,
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'KohSantepheap',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black38,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return InkWell(
      onTap: _logout,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.red.shade300),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout,
              color: Colors.red,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'Keluar',
              style: TextStyle(
                fontFamily: 'KohSantepheap',
                color: Colors.red,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
