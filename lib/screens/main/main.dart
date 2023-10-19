import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../splash_screen/splash_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Taix",
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
    );
  }
}
