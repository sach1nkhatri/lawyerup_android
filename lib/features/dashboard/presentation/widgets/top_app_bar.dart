import 'package:flutter/material.dart';

PreferredSizeWidget topAppBar() {
  return AppBar(
    backgroundColor: const Color(0xFF1E2B3A),
    title: Row(
      children: [
        Image.asset("assets/images/logo.png", height: 30),
        const SizedBox(width: 8),
        const Text("LαɯყҽɾUρ", style: TextStyle(fontSize: 20)),
      ],
    ),
  );
}
