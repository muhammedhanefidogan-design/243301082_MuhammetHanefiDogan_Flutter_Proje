import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Veritabanı işlemleri için gerekli

class kayit extends StatefulWidget {
  const kayit({super.key});

  @override
  State<kayit> createState() => _kayitState();
}

class _kayitState extends State<kayit> {
  // Verileri okumak için Controller'lar (İngilizce standartlarına uygun)
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _sifreGizli = true;

  // Firebase Kayıt Fonksiyonu
  Future<void> kayitOl() async {
    // Alanların boş olup olmadığını kontrol ediyoruz
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurunuz!')),
      );
      return;
    }

    try {
      // Firebase Firestore 'users' koleksiyonuna verileri ekliyoruz
      await FirebaseFirestore.instance.collection('users').add({
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'username': usernameController.text.trim(),
        'password': passwordController.text.trim(),
        'role': 'Personel', // Varsayılan olarak sisteme kayıt olanlar personel
        'createdAt': FieldValue.serverTimestamp(), // Kayıt tarihi
      });

      // Başarılı mesajı göster
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kayıt Başarılı! Giriş yapabilirsiniz.'),
          ),
        );
        // Kayıt olduktan sonra giriş ekranına geri dön
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Bir hata oluştu: $e')));
      }
    }
  }

  // Giriş ekranındaki aynı TextField tasarımını tekrar kullanmak için oluşturduğumuz özel widget
  Widget buildCustomTextField({
    required String hintText,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return Card(
      color: const Color(0xFFFFF0F0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: TextField(
          controller: controller,
          obscureText: isPassword ? _sifreGizli : false,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _sifreGizli ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _sifreGizli = !_sifreGizli;
                      });
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ), // Geri butonu rengi
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text(
                  "YENİ KAYIT",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 40),

                // Ad ve Soyad yan yana da olabilir, alt alta da. Şimdilik alt alta koydum.
                buildCustomTextField(
                  hintText: "Ad",
                  controller: firstNameController,
                ),
                const SizedBox(height: 20),

                buildCustomTextField(
                  hintText: "Soyad",
                  controller: lastNameController,
                ),
                const SizedBox(height: 20),

                buildCustomTextField(
                  hintText: "Kullanıcı Adı",
                  controller: usernameController,
                ),
                const SizedBox(height: 20),

                buildCustomTextField(
                  hintText: "Şifre Belirleyiniz",
                  controller: passwordController,
                  isPassword: true,
                ),
                const SizedBox(height: 40),

                // KAYIT BUTONU
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    backgroundColor: Colors.indigo,
                  ),
                  onPressed:
                      kayitOl, // Butona basıldığında Firebase fonksiyonu çalışır
                  child: const Text(
                    "KAYIT OL",
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
}
