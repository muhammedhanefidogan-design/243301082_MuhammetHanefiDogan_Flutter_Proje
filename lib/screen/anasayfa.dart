// lib/screen/anasayfa.dart
import 'package:flutter/material.dart';
import 'package:deneme/screen/talep_ekle.dart';
import 'package:deneme/screen/giris.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deneme/screen/profil.dart';
import 'package:deneme/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        title: const Text("Acil Servis Paneli"),
        backgroundColor: Colors.redAccent,
        actions: [
          // 👤 PROFİL İKONU
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: "Profilim",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilSayfasi()),
              );
            },
          ),

          // 🚪 ÇIKIŞ İKONU
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Çıkış Yap",
            onPressed: () async {
              // Kullanıcıya emin misin diye sormak fiyakalı olur
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Çıkış Yap"),
                  content: const Text(
                    "Oturumu kapatmak istediğinize emin misiniz?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("İptal"),
                    ),
                    TextButton(
                      onPressed: () async {
                        await FirebaseAuth.instance
                            .signOut(); // Firebase oturumunu kapat
                        // Giriş ekranına dön ve arkadaki tüm sayfaları temizle
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (route) => false,
                        );
                      },
                      child: const Text(
                        "Çıkış Yap",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 8), // En sağda biraz boşluk kalsın
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
