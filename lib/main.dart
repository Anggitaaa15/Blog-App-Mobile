import 'package:flutter/material.dart';
import 'package:frontend/pages/createArtikel.dart';

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
        "/buat": (context) => const BuatPage(),
      },
      initialRoute: "/buat",
    );
  }
}