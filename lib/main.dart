import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deneme/firebase_options.dart';
import 'package:deneme/screen/giris.dart';
import 'package:deneme/screen/anasayfa.dart';
import 'package:deneme/screen/admin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Acil Servis App',
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      
      home: const OturumKontrol(),
    );
  }
}

class OturumKontrol extends StatelessWidget {
  const OturumKontrol({super.key});

  @override
  Widget build(BuildContext context) {
   
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
     
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        
        if (snapshot.hasData && snapshot.data != null) {
          
          String uid = snapshot.data!.uid;

         
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('kullanicilar')
                .doc(uid)
                .get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              
              if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                return const giris();
              }

              
              var userData = userSnapshot.data!.data() as Map<String, dynamic>;
              String rol = userData['rol'] ?? 'Personel';

              
              if (rol == 'Admin') {
                return const AdminAnasayfa();
              } else {
                return const anasayfa();
              }
            },
          );
        }

       
        return const giris();
      },
    );
  }
}
