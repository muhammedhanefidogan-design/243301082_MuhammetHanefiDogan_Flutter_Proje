import 'package:flutter/material.dart';

// Class ismini senin dediğin gibi küçük yaptık
class anasayfa extends StatefulWidget {
  const anasayfa({super.key});

  @override
  State<anasayfa> createState() => _anasayfaState();
}

class _anasayfaState extends State<anasayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acil Servis Paneli'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hoş Geldiniz',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                // LOG KAYDI (Hoca kuralı)
                print("LOG: Yeni sayfa butona basıldı.");

                // Buraya 'Navigator.push' gelecek,
                // Diğer dosyanın class ismi neyse onu buraya yazacağız.
              },
              child: const Text(
                'Yeni Sayfaya Git',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
