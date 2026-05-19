import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const FiliSignApp());
}

class FiliSignApp extends StatelessWidget {
  const FiliSignApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FiliSign',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6200EE),
          primary: const Color(0xFF6200EE),
          secondary: const Color(0xFF03DAC6),
          surface: Colors.white,
          background: const Color(0xFFF8F9FE),
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.outfitTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
