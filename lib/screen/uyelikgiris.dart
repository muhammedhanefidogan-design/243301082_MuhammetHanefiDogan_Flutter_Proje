import 'package:deneme/screen/sayfa2.dart';
import 'package:flutter/material.dart';

import '../conta.dart';

class homes extends StatelessWidget {
  const homes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Custom(),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const homes2()),
                );
              },
              child: Text("ikinci ekran"),
            ),
          ],
        ),
      ),
    );
  }
}
