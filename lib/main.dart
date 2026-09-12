import 'package:flutter/material.dart';
import 'package:frontend/pages/jelajahiPage.dart';
import 'package:google_fonts/google_fonts.dart'; 

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
      "/jelajahi": (context) => JelajahiPage(),
    },

    initialRoute: "/jelajahi",

    theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
    );
  }
}