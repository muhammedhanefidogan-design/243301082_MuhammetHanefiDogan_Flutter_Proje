import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deneme/screen/giris.dart'; // Eğer çıkış butonu yapacaksan bunu da ekle

class AdminAnasayfa extends StatefulWidget {
  const AdminAnasayfa({super.key});

  @override
  State<AdminAnasayfa> createState() => _AdminAnasayfaState();
}

class _AdminAnasayfaState extends State<AdminAnasayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8),
      appBar: AppBar(
        title: const Text(
          "ADMİN KONTROL PANELİ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF001F3F),
        foregroundColor: Colors.white,
        elevation: 0,
        // 🚨 ÇIKIŞ BUTONUNU BURAYA EKLİYORUZ:
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.redAccent),
            tooltip: "Çıkış Yap",
            onPressed: () {
              // Admin'i giriş ekranına geri gönderiyoruz ve geri dönmesini engelliyoruz
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const giris()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('talepler')
            .orderBy('olusturulma_tarihi', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Hata: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Bekleyen talep yok."));
          }

          var talepler = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: talepler.length,
            itemBuilder: (context, index) {
              // 🚨 Belgenin ID'sini (`doc.id`) ve verilerini alıyoruz
              var doc = talepler[index];
              var talep = doc.data() as Map<String, dynamic>;
              String docId = doc.id;

              bool isKritik = talep['oncelik'] == 'Kritik';
              Color durumRengi = isKritik ? Colors.red : Colors.orange;
              bool isIslemde = talep['durum'] == 'İşlemde';

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(
                    color: durumRengi.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              talep['baslik'] ?? 'İsimsiz',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: durumRengi.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              talep['oncelik'] ?? 'Belirsiz',
                              style: TextStyle(
                                color: durumRengi,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Kategori: ${talep['kategori'] ?? 'Belirsiz'}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 10),

                      // EĞER İŞLEMDEYSE ONAY İKONU, DEĞİLSE YÖNLENDİRME BUTONU
                      isIslemde
                          ? Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle, color: Colors.green),
                                  SizedBox(width: 8),
                                  Text(
                                    "Birim Yönlendirildi",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3F51B5),
                                minimumSize: const Size(double.infinity, 45),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                // 🚨 BURASI SİHİRLİ SATIR: Doğru ID'ye sahip talebi bul ve 'durum' alanını 'İşlemde' yap!
                                await FirebaseFirestore.instance
                                    .collection('talepler')
                                    .doc(docId)
                                    .update({'durum': 'İşlemde'});

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Talep güncellendi! Personel ekranına düşecek.",
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 18,
                              ),
                              label: const Text(
                                "İLGİLİ BİRİME YÖNLENDİR",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
