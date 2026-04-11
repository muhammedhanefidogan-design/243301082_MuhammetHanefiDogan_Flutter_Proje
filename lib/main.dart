import 'package:flutter/material.dart';
import 'package:deneme/screen/giris.dart'; // Yeni oluşturduğun dosyayı tanıttık

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.red),
      // Uygulama ilk açıldığında giris.dart'a gider
      home: const giris(),
    );
  }
}
