import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilSayfasi extends StatelessWidget {
  const ProfilSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    // Mevcut giriş yapmış kullanıcının UID'sini alıyoruz
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Bilgilerim"),
        backgroundColor: Colors.redAccent,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        // Firestore'daki 'users' koleksiyonundan veriyi çekiyoruz
        future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Kullanıcı bilgisi bulunamadı."));
          }

          // Verileri değişkenlere atayalım
          var data = snapshot.data!.data() as Map<String, dynamic>;
          String adSoyad = data['adSoyad'] ?? "İsim Yok";
          String email = data['email'] ?? "Email Yok";
          String rol = data['rol'] ?? "Rol Yok";

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.redAccent,
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.badge, color: Colors.redAccent),
                  title: const Text("Ad Soyad"),
                  subtitle: Text(
                    adSoyad,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.email, color: Colors.redAccent),
                  title: const Text("E-posta"),
                  subtitle: Text(email, style: const TextStyle(fontSize: 16)),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.verified_user,
                    color: Colors.redAccent,
                  ),
                  title: const Text("Yetki Durumu"),
                  subtitle: Text(
                    rol,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                // ÇIKIŞ BUTONU
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    "OTURUMU KAPAT",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
