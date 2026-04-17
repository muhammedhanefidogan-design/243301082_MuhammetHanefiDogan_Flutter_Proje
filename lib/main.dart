import 'package:flutter/material.dart';
import 'package:deneme/screen/giris.dart'; // Yeni oluşturduğun dosyayı tanıttık
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // 🚨 İŞTE EKSİK OLAN HAYAT KURTARICI SATIR!

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🚨 Firebase'i gizli anahtarlarımızla (options) uyandırıyoruz
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
