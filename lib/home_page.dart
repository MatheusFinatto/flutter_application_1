import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/Input.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Bem vindo user.name!')),
        body: Scaffold(
          body: Container(
              padding: const EdgeInsets.all(32),
              child: Input(placeholder: "Pesquise ou use o mapa :)")),
        ));
  }
}
