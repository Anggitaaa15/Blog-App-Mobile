import 'package:flutter/material.dart';
import 'package:frontend/pages/artikelSaya.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      routes: {
        "/artikelSaya": (context) => const Artikelsaya(),
      },

      initialRoute: "/artikelSaya",
    );
  }
}