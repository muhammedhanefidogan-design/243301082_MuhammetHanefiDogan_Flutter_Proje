import 'package:flutter/material.dart';

class TalepEkle extends StatefulWidget {
  const TalepEkle({super.key});

  @override
  State<TalepEkle> createState() => _TalepEkleState();
}

class _TalepEkleState extends State<TalepEkle> {
  // Formdaki verileri kontrol etmek için seçiciler
  String seciliKategori = "Teknik Arıza";
  String seciliOncelik = "Normal";
  final TextEditingController cihazController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8), // Ferah arka plan
      appBar: AppBar(
        title: const Text("YENİ TALEP OLUŞTUR"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. KATEGORİ SEÇİMİ (TEKNİK, LOJİSTİK VB.)
                const Text(
                  "Talep Kategorisi",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 4,
                  color: const Color(0xFFFFF1F1), // Pudra pembesi
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: seciliKategori,
                        isExpanded: true,
                        items:
                            [
                                  "Teknik Arıza",
                                  "Lojistik İkmal",
                                  "Temizlik/Hijyen",
                                ]
                                .map(
                                  // İŞTE HATA BURADAYDI! <String> EKLENDİ
                                  (e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) =>
                            setState(() => seciliKategori = val!),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 2. CİHAZ / İHTİYAÇ ADI (Örn: Defibrilatör)
                Card(
                  elevation: 4,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: TextField(
                      controller: cihazController,
                      decoration: const InputDecoration(
                        hintText: "Cihaz veya İhtiyaç Adı (Örn: Defibrilatör)",
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.medical_services,
                          color: Color(0xFF3F51B5),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // 3. ÖNCELİK DURUMU (KRİTİK, NORMAL)
                const Text(
                  "Öncelik Durumu",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text("Kritik"),
                      selected: seciliOncelik == "Kritik",
                      selectedColor: Colors.red[100],
                      onSelected: (s) =>
                          setState(() => seciliOncelik = "Kritik"),
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      label: const Text("Normal"),
                      selected: seciliOncelik == "Normal",
                      onSelected: (s) =>
                          setState(() => seciliOncelik = "Normal"),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // 4. AÇIKLAMA ALANI
                Card(
                  elevation: 4,
                  color: const Color(0xFFFFF1F1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: TextField(
                      maxLines: 3, // Uzun yazı yazılabilsin
                      decoration: InputDecoration(
                        hintText: "Arıza veya talep detayı nedir?",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // GÖNDER BUTONU
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3F51B5), // Lacivert/Mavi
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    // Yazılanları bir paket yapıp (Map) anasayfaya geri fırlatıyoruz!
                    Navigator.pop(context, {
                      'baslik': cihazController.text.isEmpty
                          ? "Belirtilmedi"
                          : cihazController.text,
                      'kategori': seciliKategori,
                      'oncelik': seciliOncelik,
                    });
                  },
                  child: const Text(
                    "TALEBİ SİSTEME İŞLE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
