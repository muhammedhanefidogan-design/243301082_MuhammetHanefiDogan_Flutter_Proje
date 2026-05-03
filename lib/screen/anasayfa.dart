// lib/screen/anasayfa.dart
import 'package:flutter/material.dart';
import 'package:deneme/screen/talep_ekle.dart';
import 'package:deneme/screen/giris.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        title: const Text("AKTİF TALEPLER"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.red),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const giris()),
              );
            },
          ),
        ],
      ),

      // 🚨 CANLI FİREBASE DİNLEYİCİSİ (StreamBuilder)
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('talepler')
            .orderBy('olusturulma_tarihi', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Hata oluştu: ${snapshot.error}"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("Henüz aktif talep yok."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final veri = docs[index].data() as Map<String, dynamic>;

              Color renk = (veri['oncelik'] == 'Kritik')
                  ? Colors.red
                  : Colors.orange;

              // 🚨 BURASI ÇOK ÖNEMLİ:
              // Veritabanından gelen 'durum' alanını kartın içine direkt basıyoruz!
              return _talepKarti(
                veri['baslik'] ?? 'Başlıksız',
                veri['kategori'] ?? 'Kategorisiz',
                veri['oncelik'] ?? 'Normal',
                veri['durum'] ??
                    'Bekliyor', // Admin bunu 'İşlemde' yapınca anında buraya yansıyacak!
                renk,
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TalepEkle()),
          );
        },
        backgroundColor: const Color(0xFF3F51B5),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "YENİ TALEP",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // 🚨 KART ŞABLONU (Durumu veritabanından çekip gösteriyoruz)
  Widget _talepKarti(
    String baslik,
    String kategori,
    String oncelik,
    String durum, // Admin'in güncellediği 'durum' buraya geliyor
    Color durumRengi,
  ) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: CircleAvatar(
          backgroundColor: durumRengi.withOpacity(0.2),
          child: Icon(Icons.warning_amber_rounded, color: durumRengi),
        ),
        title: Text(
          baslik,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          "$kategori\nAcil Servis - Mavi Alan",
          style: const TextStyle(height: 1.5),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              oncelik,
              style: TextStyle(color: durumRengi, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            // 🚨 Admin "İşlemde" yapınca burası saniyesinde değişecek:
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: durum == 'İşlemde' ? Colors.green[50] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                durum,
                style: TextStyle(
                  color: durum == 'İşlemde' ? Colors.green : Colors.grey[700],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
