import 'package:flutter/material.dart';

class Dados_EmpresaScreen extends StatefulWidget {
  const Dados_EmpresaScreen({Key? key}) : super(key: key);

  @override
  Dados_EmpresaScreenState createState() => Dados_EmpresaScreenState();
}

class Dados_EmpresaScreenState extends State<Dados_EmpresaScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empresa'),
      ),
      body: Column(children: [Text('Hello world')]),
    );
  }
}
