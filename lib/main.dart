import 'package:flutter/material.dart';
import 'package:frontend/pages/profil.dart';
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
        "/profil": (context) => const ProfilPage(),
        "/artikelSaya": (context) => const Artikelsaya(),
      },

      initialRoute: "/profil",
    );
  }
}