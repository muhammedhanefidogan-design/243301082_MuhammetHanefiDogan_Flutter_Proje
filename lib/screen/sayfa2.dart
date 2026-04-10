import 'package:flutter/material.dart';

class homes2 extends StatelessWidget {
  const homes2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text("deneme"),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("ekranı kapa"),
            ),
          ],
        ),
      ),
    );
  }
}
