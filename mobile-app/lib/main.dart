import 'package:flutter/material.dart';
import 'package:mobile_puskesmas/screens/main_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Puskesmas SBB',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF06489F),
        fontFamily: 'KohSantepheap',
      ),
      home: const MainLayout(),
    );
  }
}
