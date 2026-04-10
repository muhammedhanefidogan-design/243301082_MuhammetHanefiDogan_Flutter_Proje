import 'package:flutter/material.dart';

class Custom extends StatelessWidget {
  const Custom({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(50),
      decoration: BoxDecoration(
        color: Colors.cyan,
        borderRadius: BorderRadius.circular(24),
      ),

      child: Text(
        "borno",
        style: TextStyle(color: Colors.yellowAccent, fontSize: 40),
      ),
    );
  }
}
