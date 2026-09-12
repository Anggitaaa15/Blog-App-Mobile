import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,

    routes: {
      "/home": (context) => HomePage(),
      "/jelajahi": (context) => JelajahiPage(),
      "/buat": (context) => BuatPage(),
      "/artikel-saya": (context) => ArtikelSayaPage(),
      "/profil": (context) => ProfilPage(),
    },

    initialRoute: "/home",
    );
  }
}