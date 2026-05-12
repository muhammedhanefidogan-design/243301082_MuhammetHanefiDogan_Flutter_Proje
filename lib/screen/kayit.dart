import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deneme/screen/giris.dart';

class kayit extends StatefulWidget {
  const kayit({super.key});

  @override
  State<kayit> createState() => _kayitState();
}

class _kayitState extends State<kayit> {
  // 🚨 KONTROLCÜLER
  final TextEditingController _adSoyadController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();

  String seciliRol = "Personel"; // Varsayılan rol
  bool _sifreGizli = true;
  bool _yukleniyor = false;

  // 🚀 KAYIT OLMA FONKSİYONU
  void _kayitOl() async {
    final adSoyad = _adSoyadController.text.trim();
    final email = _emailController.text.trim();
    final sifre = _sifreController.text.trim();

    if (adSoyad.isEmpty || email.isEmpty || sifre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lütfen tüm alanları doldurun!"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _yukleniyor = true;
    });

    try {
      // 1. Firebase Auth ile Kullanıcı Oluştur
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: sifre);

      // 2. Firestore'a Ad-Soyad ve Rol Bilgisini Kaydet
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
            'adSoyad': adSoyad,
            'email': email,
            'rol': seciliRol,
            'kayitTarihi': FieldValue.serverTimestamp(),
          });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kayıt başarıyla tamamlandı!"),
          backgroundColor: Colors.green,
        ),
      );

      // 3. Giriş Ekranına Yönlendir
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const giris()),
      );
    } on FirebaseAuthException catch (e) {
      String mesaj = "Kayıt başarısız!";

      // Detaylı hata kontrolü
      if (e.code == 'email-already-in-use') {
        mesaj = "Bu e-posta zaten kullanımda!";
      } else if (e.code == 'weak-password') {
        mesaj = "Şifre çok zayıf! (En az 6 karakter olmalı)";
      } else if (e.code == 'invalid-email') {
        mesaj = "Geçersiz e-posta formatı!";
      } else {
        mesaj = "Firebase Hatası: ${e.message}"; // Asıl hatayı burada görürüz
      }

      print(
        "🚨 FIREBASE HATASI: ${e.code} - ${e.message}",
      ); // Terminale de yazar

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mesaj), backgroundColor: Colors.red),
      );
    } catch (e) {
      print("🚨 BEKLENMEDIK HATA: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Bir hata oluştu: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _yukleniyor = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Yeni Kayıt"),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Icon(Icons.person_add, size: 80, color: Colors.red),
                const SizedBox(height: 20),
                const Text(
                  "Sisteme Kayıt Ol",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                // 👤 AD SOYAD KARTI
                _buildInputCard(_adSoyadController, "Ad Soyad", Icons.person),
                const SizedBox(height: 15),

                // 📧 E-POSTA KARTI
                _buildInputCard(
                  _emailController,
                  "E-posta",
                  Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15),

                // 🔑 ŞİFRE KARTI
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5,
                    ),
                    child: TextField(
                      controller: _sifreController,
                      obscureText: _sifreGizli,
                      decoration: InputDecoration(
                        hintText: "Şifre",
                        border: InputBorder.none,
                        icon: const Icon(Icons.lock, color: Colors.redAccent),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _sifreGizli
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () =>
                              setState(() => _sifreGizli = !_sifreGizli),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 🎭 ROL SEÇİMİ
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text("Personel"),
                      selected: seciliRol == "Personel",
                      onSelected: (val) =>
                          setState(() => seciliRol = "Personel"),
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      label: const Text("Admin"),
                      selected: seciliRol == "Admin",
                      onSelected: (val) => setState(() => seciliRol = "Admin"),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // 🚀 KAYIT BUTONU
                _yukleniyor
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(200, 50),
                          backgroundColor: Colors.red,
                        ),
                        onPressed: _kayitOl,
                        child: const Text(
                          "KAYDI TAMAMLA",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Yardımcı Widget: Giriş Kartları için
  Widget _buildInputCard(
    TextEditingController controller,
    String hint,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            icon: Icon(icon, color: Colors.redAccent),
          ),
        ),
      ),
    );
  }
}
