import 'package:flutter/material.dart';
// Yeni oluşturduğumuz sayfayı buraya import etmeliyiz ki tanısın
import 'package:deneme/screen/talep_ekle.dart'; // "deneme" yerine kendi proje adını yazmayı unutma!

class anasayfa extends StatefulWidget {
  const anasayfa({super.key});

  @override
  State<anasayfa> createState() => _anasayfaState();
}

// Geçici hafızamız (Uygulama kapanana kadar burada dururlar)
List<Map<String, dynamic>> aktifTalepler = [
  {
    "baslik": "Defibrilatör Arızası",
    "kategori": "Teknik Arıza",
    "oncelik": "Kritik",
  },
  {"baslik": "Oksijen Tüpü", "kategori": "Lojistik İkmal", "oncelik": "Normal"},
];

class _anasayfaState extends State<anasayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ANA LİSTE (Şimdilik örnek 2 tane talep koyalım)
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount:
            aktifTalepler.length, // Listede kaç eleman varsa o kadar kart çiz
        itemBuilder: (context, index) {
          final talep = aktifTalepler[index];
          // Kritikse kırmızı, normalse turuncu renk atayalım
          Color renk = talep['oncelik'] == 'Kritik'
              ? Colors.red
              : Colors.orange;

          return _talepKarti(
            talep['baslik'],
            talep['kategori'],
            talep['oncelik'],
            renk,
          );
        },
      ),

      // İŞTE SENİN SORDUĞUN KISIM: TALEP EKLE BUTONU
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // async ekledik çünkü diğer sayfanın kapanmasını bekleyeceğiz
          // Form sayfasına git ve oradan gelecek "sonuc" verisini bekle
          final sonuc = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TalepEkle()),
          );

          // Eğer kullanıcı formu doldurup gönderdiyse (geri tuşuna basıp boş dönmediyse)
          if (sonuc != null) {
            setState(() {
              aktifTalepler.insert(
                0,
                sonuc,
              ); // Yeni talebi listenin en tepesine ekle!
            });
          }
        },
        backgroundColor: const Color(0xFF3F51B5), // Lacivert/Mavi tonumuz
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "YENİ TALEP",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Listede görünecek kartların şablonu (Kod kalabalığı olmasın diye ayırdık)
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
