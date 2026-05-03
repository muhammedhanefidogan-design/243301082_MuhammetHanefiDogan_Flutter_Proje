import 'package:flutter/material.dart';
import 'package:deneme/screen/anasayfa.dart';
import 'package:deneme/screen/admin.dart';
import 'package:deneme/screen/kayit.dart';

class giris extends StatefulWidget {
  const giris({super.key});

  @override
  State<giris> createState() => _girisState();
}

bool _sifreGizli = true;

class _girisState extends State<giris> {
  String seciliRol = "Personel";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors
          .grey[100], // Arka planı hafif gri yapalım ki kartlar belli olsun
      body: Center(
        child: SingleChildScrollView(
          // Klavye açılınca ekran kaymasın diye
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text(
                  "ACİL SERVİS GİRİŞİ",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text("Personel"),
                      selected: seciliRol == "Personel",
                      showCheckmark: false,
                      onSelected: (bool selected) {
                        setState(() {
                          seciliRol = "Personel";
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      label: const Text("Admin"),
                      selected: seciliRol == "Admin",
                      showCheckmark: false,
                      onSelected: (bool selected) {
                        setState(() {
                          seciliRol = "Admin";
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // KULLANICI ADI KARTI
                Card(
                  color: const Color(0xFFFFF0F0),
                  elevation: 4, // Gölge miktarı
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Kullanıcı Adı",
                        border: InputBorder
                            .none, // Kartın içinde olduğu için çizgiyi sildik
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ŞİFRE KARTI
                // ŞİFRE KARTI - const'u kaldır, obscureText ve suffixIcon ekle
                Card(
                  elevation: 4,
                  color: const Color(0xFFFFF0F0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    // const yok çünkü _sifreGizli state'e bağlı
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5,
                    ),
                    child: TextField(
                      obscureText: _sifreGizli, // true ise şifre nokta gösterir
                      decoration: InputDecoration(
                        hintText: "Şifrenizi Giriniz",
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _sifreGizli
                                ? Icons.visibility_off
                                : Icons.visibility, // göz ikonu
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _sifreGizli =
                                  !_sifreGizli; // her basışta tersine çevirir
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // GİRİŞ BUTONU
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(
                      200,
                      50,
                    ), // Genişlik 250, Yükseklik 70
                    backgroundColor: Colors.indigo,
                  ),
                  onPressed: () {
                    // HOCA İÇİN LOG KAYDI
                    print("LOG: $seciliRol giriş yaptı.");

                    if (seciliRol == "Admin") {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminAnasayfa(),
                        ),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const anasayfa(),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "GİRİŞ YAP",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const kayit()),
                    );
                  },
                  child: const Text(
                    "Hesabın yok mu? Kayıt Ol",
                    style: TextStyle(color: Colors.black),
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
