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

      // Firebase'den veriyi canlı çeken kısım
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('talepler')
            .orderBy('olusturulma_tarihi', descending: true) // En yeni en üstte
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SelectableText(
                  "ASIL HATA ŞU: ${snapshot.error}",
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("Henüz aktif talep yok."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final veri = docs[index].data() as Map<String, dynamic>;

              // Firebase'den gelen verilere göre kartı çiziyoruz
              Color renk = (veri['oncelik'] == 'Kritik')
                  ? Colors.red
                  : Colors.orange;

              return _talepKarti(
                veri['baslik'] ?? 'Başlıksız',
                veri['kategori'] ?? 'Kategorisiz',
                veri['oncelik'] ?? 'Normal',
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

  Widget _talepKarti(
    String baslik,
    String kategori,
    String durum,
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
              durum,
              style: TextStyle(color: durumRengi, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Bekliyor",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
