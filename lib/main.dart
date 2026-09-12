import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,

    routes: {
      "/home": (context) => HomePage(),
    },

    initialRoute: "/home",

    theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
    );
  }
}