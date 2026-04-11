import 'package:flutter/material.dart';

class admin extends StatefulWidget {
  const admin({super.key});

  @override
  State<admin> createState() => _adminState();
}

class _adminState extends State<admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.red[50], // Admin ekranı hafif farklı bir renk olsun
      appBar: AppBar(
        title: const Text("ADMİN PANELİ - YÖNETİM"),
        backgroundColor: Colors.black, // Adminin havası farklı olsun
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text("Personel Talepleri ve Sistem Ayarları Burada"),
      ),
    );
  }
}
