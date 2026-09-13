import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/pages/profil.dart';
import 'package:frontend/pages/artikelSaya.dart';
import 'package:frontend/pages/homePage.dart';
import 'package:frontend/pages/createArtikel.dart';
import 'package:frontend/pages/jelajahiPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),

      routes: {
        "/beranda": (context) => Homepage(),
        "/jelajahi": (context) => JelajahiPage(),
        "/buat": (context) => BuatPage(),
        "/artikelSaya": (context) => Artikelsaya(),
        "/profil": (context) => ProfilPage(),
      },

      initialRoute: "/beranda",
    );
  }
}