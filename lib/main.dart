import 'package:deneme/screen/sayfa.dart';
import 'package:flutter/material.dart';

import 'conta.dart';

// EKSİK OLAN KISIM BURASI:
void main() {
  runApp(const MyWidget());
}

// Senin yazdığın widget buraya gelecek:
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: homes());
  }
}
