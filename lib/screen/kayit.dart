import 'package:flutter/material.dart';

class kayit extends StatefulWidget {
  const kayit({super.key});

  @override
  State<kayit> createState() => _kayitState();
}

bool _sifreGizli = true; // Şifre başta gizli başlasın

class _kayitState extends State<kayit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F0F0),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 20.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "YENİ KAYIT",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE53935),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 30),

                // AD SOYAD
                Card(
                  elevation: 4,
                  color: const Color(0xFFFFF0F0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Ad Soyad Giriniz",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // E-POSTA
                Card(
                  elevation: 4,
                  color: const Color(0xFFFFF0F0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "E-posta Adresiniz",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // ŞİFRE
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
                        hintText: "Şifre Belirleyiniz",
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

                // KAYIT BUTONU
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A237E),
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "KAYIT OL",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
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
