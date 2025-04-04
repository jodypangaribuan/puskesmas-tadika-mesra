import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mobile_puskesmas/screens/patient_registration_screen.dart';
import 'package:mobile_puskesmas/models/user_model.dart';
import 'package:mobile_puskesmas/services/auth_service.dart';
import 'package:mobile_puskesmas/screens/medical_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<String> carouselImages = [
      'assets/images/carousel-1.jpg',
      'assets/images/carousel-2.jpg',
      'assets/images/carousel-3.jpg',
    ];

    // Set status bar to be transparent with dark icons
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Custom header integrated directly
          _buildHeader(),

          // Content area
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Small gap before carousel
                  const SizedBox(height: 5),

                  // Carousel section
                  Stack(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          height: MediaQuery.of(context).size.height * 0.3,
                          viewportFraction: 1.0,
                          enlargeCenterPage: false,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ),
                        items: carouselImages.map((image) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: carouselImages.asMap().entries.map((entry) {
                            return Container(
                              width: 8.0,
                              height: 8.0,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(
                                  _currentIndex == entry.key ? 0.9 : 0.4,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  // Menu section
                  Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width *
                        0.04), // Responsive padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _buildMenuItem(
                              image: 'assets/images/pendaftaran-logo.png',
                              title: 'Pendaftaran',
                              color: const Color(0xFF06489F),
                              onTap: () {
                                // Handle pendaftaran tap
                                _handlePatientRegistration(context);
                              },
                            ),
                            _buildMenuItem(
                              image: 'assets/images/rekam-medis-logo.png',
                              title: 'Rekam Medis',
                              color: const Color(0xFF06489F),
                              onTap: () {
                                // Handle rekam medis tap
                              },
                            ),
                            _buildMenuItem(
                              image: 'assets/images/jadwal-dokter-logo.png',
                              title: 'Jadwal Dokter',
                              color: const Color(0xFF06489F),
                              onTap: () {
                                // Handle jadwal dokter tap
                              },
                            ),
                            _buildMenuItem(
                              image: 'assets/images/feedback-logo.png',
                              title: 'Feedback',
                              color: const Color(0xFF06489F),
                              onTap: () {
                                // Handle feedback tap
                              },
                            ),
                            _buildMenuItem(
                              image: 'assets/images/pengumuman-logo.png',
                              title: 'Pengumuman',
                              color: const Color(0xFF06489F),
                              onTap: () {
                                // Handle pengumuman tap
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Riwayat berobat section
                  _buildRiwayatBerobatSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    // Get the status bar height and screen size
    final MediaQueryData mediaQuery =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    final double statusBarHeight = mediaQuery.padding.top;
    final double screenWidth = mediaQuery.size.width;

    // Calculate responsive sizes based on screen width
    final double headerHeight =
        mediaQuery.size.height * 0.09; // 9% of screen height
    final double logoSize = screenWidth * 0.24; // 24% of screen width
    final double titleFontSize = screenWidth * 0.05; // 5% of screen width
    final double subtitleFontSize = screenWidth * 0.032; // 2.8% of screen width

    return Container(
      height: headerHeight + statusBarHeight,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Stack(
          children: [
            // Blue background positioned to overlap with logo
            Positioned(
              left: logoSize * 0.85, // Relative to logo size
              top: 0,
              bottom: 0,
              right: screenWidth * 0.04, // 4% of screen width
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF06489F),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.055), // Responsive padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'PUSMASIB',
                        style: TextStyle(
                          fontFamily: 'YesevaOne',
                          color: Colors.white,
                          fontSize: titleFontSize,
                          height: 1.4,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'PUSKESMAS SIBORONGBORONG',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: subtitleFontSize,
                          height: 1.0,
                          fontWeight: FontWeight.normal,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Logo on top of the stack to ensure visibility
            Positioned(
              left: -screenWidth *
                  0.015, // Small negative value relative to screen width
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  width: logoSize,
                  height: logoSize,
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String image,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    // Get screen dimensions for responsive sizing
    final double screenWidth = MediaQuery.of(context).size.width;

    // Calculate sizes based on screen width
    final double iconSize = screenWidth * 0.15; // 15% of screen width
    final double fontSize = screenWidth * 0.023; // 2.5% of screen width

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: iconSize,
              height: iconSize,
              padding: EdgeInsets.all(screenWidth * 0.01), // Responsive padding
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                image,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: screenWidth * 0.008), // Responsive spacing
            Text(
              title,
              style: TextStyle(
                fontFamily: 'KohSantepheap',
                color: color,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiwayatBerobatSection() {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Riwayat Berobat',
            style: TextStyle(
              fontFamily: 'KohSantepheap',
              fontSize: MediaQuery.of(context).size.width * 0.045,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF06489F),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.width * 0.02),
          _buildRiwayatBerobatItem(),
          _buildRiwayatBerobatItem(),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {
                // Navigate to detailed medical history
              },
              child: Text(
                'Lihat Semua',
                style: TextStyle(
                  color: const Color(0xFF06489F),
                  fontSize: MediaQuery.of(context).size.width * 0.035,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiwayatBerobatItem() {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(bottom: screenWidth * 0.025),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left section - Hospital illustration
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.asset(
              'assets/images/hospital-illustration.png', // Make sure to add this image
              width: screenWidth * 0.22,
              height: screenWidth * 0.22,
              fit: BoxFit.cover,
            ),
          ),

          // Right section - Visit details
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date and time
                  Text(
                    'Selasa, 16 Februari 2025, 18.00 WIB',
                    style: TextStyle(
                      fontFamily: 'KohSantepheap',
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.032,
                      color: const Color(0xFF06489F),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.02),

                  // Diagnosis
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.medical_information_outlined,
                        size: screenWidth * 0.04,
                        color: Colors.grey[700],
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      Expanded(
                        child: Text(
                          'Diagnosis Pelayanan',
                          style: TextStyle(
                            fontFamily: 'KohSantepheap',
                            fontSize: screenWidth * 0.03,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenWidth * 0.01),

                  // Treatment
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.message_outlined,
                        size: screenWidth * 0.04,
                        color: Colors.grey[700],
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      Expanded(
                        child: Text(
                          'Terapi Obat',
                          style: TextStyle(
                            fontFamily: 'KohSantepheap',
                            fontSize: screenWidth * 0.03,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // See more button
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.03),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'See More ...',
                style: TextStyle(
                  fontFamily: 'KohSantepheap',
                  fontSize: screenWidth * 0.026,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handlePatientRegistration(BuildContext context) async {
    // Check if user is logged in
    final bool isLoggedIn = await AuthService().isLoggedIn();

    if (!isLoggedIn) {
      // If not logged in, show message to login first
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Silakan login terlebih dahulu untuk mendaftar sebagai pasien'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Check if already registered as patient
    final bool isPatient = await AuthService().isPatient();

    if (isPatient) {
      // If already a patient, navigate to medical appointment screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MedicalScreen(),
        ),
      );
      return;
    }

    // Navigate to patient registration screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientRegistrationScreen(
          onRegistrationSuccess: () {
            // Refresh the screen or data after successful registration
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Pendaftaran pasien berhasil!'),
                backgroundColor: Colors.green,
              ),
            );
          },
        ),
      ),
    );
  }
}
