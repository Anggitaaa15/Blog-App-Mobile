import 'package:flutter/material.dart';
import 'package:frontend/pages/profil.dart';
import 'package:frontend/pages/artikelSaya.dart';
import 'package:frontend/pages/homePage.dart';

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
        "/profil": (context) => ProfilPage(),
        "/artikelSaya": (context) => Artikelsaya(),
        "/beranda": (context) => Homepage()
      },

      initialRoute: "/profil",
    );
  }
}