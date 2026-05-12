import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deneme/screen/anasayfa.dart';
import 'package:deneme/screen/admin.dart';
import 'package:deneme/screen/kayit.dart';

class giris extends StatefulWidget {
  const giris({super.key});

  @override
  State<giris> createState() => _girisState();
}

class _girisState extends State<giris> {
  // 🚨 TEXTFIELD'LAR İÇİN KONTROLCÜLER
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();

  String seciliRol = "Personel";
  bool _sifreGizli = true;
  bool _yukleniyor = false; // Giriş yaparken dönecek yüklenme ikonu için

  // 🚀 GİRİŞ YAPMA FONKSİYONU
  void _girisYap() async {
    // 1. Boşluk Kontrolü
    if (_emailController.text.trim().isEmpty ||
        _sifreController.text.trim().isEmpty) {
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
      // 2. Firebase ile Giriş Yapmayı Dene
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _sifreController.text.trim(),
          );

      String uid = userCredential.user!.uid;

      // 3. Firestore'dan Kullanıcının Rolünü Çek
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        String rol = userDoc.get('rol') ?? 'Personel';

        // 🚨 Seçilen rol ile veritabanındaki rol uyuşuyor mu kontrolü (Opsiyonel Güvenlik)
        if (rol != seciliRol) {
          await FirebaseAuth.instance
              .signOut(); // Yanlış rol seçtiyse oturumu kapat
          throw 'Seçtiğiniz rol ile hesabınız uyuşmuyor!';
        }

        // 4. Doğru Sayfaya Yönlendir
        if (rol == 'Admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminAnasayfa()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const anasayfa()),
          );
        }
      } else {
        throw 'Kullanıcı bilgileri veritabanında bulunamadı!';
      }
    } on FirebaseAuthException catch (e) {
      // 🚨 Hata Mesajlarını Yakala
      String hataMesaji = "Giriş başarısız!";
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        hataMesaji = "E-posta veya şifre hatalı!";
      } else if (e.code == 'invalid-email') {
        hataMesaji = "Geçersiz e-posta formatı!";
      } else {
        hataMesaji = e.message ?? hataMesaji;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(hataMesaji), backgroundColor: Colors.red),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _yukleniyor = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _sifreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
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
                // 📧 KULLANICI ADI (E-POSTA) KARTI
                Card(
                  color: const Color(0xFFFFF0F0),
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
                      controller: _emailController, // Kontrolcü bağlandı
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "E-posta Adresi",
                        border: InputBorder.none,
                        icon: Icon(Icons.email, color: Colors.redAccent),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // 🔑 ŞİFRE KARTI
                Card(
                  elevation: 4,
                  color: const Color(0xFFFFF0F0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5,
                    ),
                    child: TextField(
                      controller: _sifreController, // Kontrolcü bağlandı
                      obscureText: _sifreGizli,
                      decoration: InputDecoration(
                        hintText: "Şifrenizi Giriniz",
                        border: InputBorder.none,
                        icon: const Icon(Icons.lock, color: Colors.redAccent),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _sifreGizli
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _sifreGizli = !_sifreGizli;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // 🚨 GİRİŞ BUTONU VE YÜKLENİYOR İKONU
                _yukleniyor
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(200, 50),
                          backgroundColor: Colors.indigo,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _girisYap, // Tetiklenen fonksiyon
                        child: const Text(
                          "GİRİŞ YAP",
                          style: TextStyle(color: Colors.white, fontSize: 16),
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
