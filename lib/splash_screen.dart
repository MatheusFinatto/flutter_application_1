// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToMainScreen(); // Função para navegar para a tela principal após um atraso
  }

  Future<void> _navigateToMainScreen() async {
    await Future.delayed(const Duration(seconds: 3)); // Atraso de 3 segundos
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => HomePage()), // Tela principal do app
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'TAIX',
          style: GoogleFonts.fasterOne(fontSize: 72),
        ),
      ),
    );
  }
}
