import 'package:flutter/material.dart';
import 'package:flutter_birthday_wish_app/intro_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const BirthdaySurpriseApp());
}

class BirthdaySurpriseApp extends StatelessWidget {
  const BirthdaySurpriseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Birthday Surprise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const IntroScreen(),
    );
  }
}
