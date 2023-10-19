import 'package:flutter/material.dart';

class AtividadesScreen extends StatelessWidget {
  const AtividadesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atividades'),
      ),
      body: const Column(
        children: [
          // Search input field
          Padding(
            padding: EdgeInsets.all(16.0),
          ),
        ],
      ),
    );
  }
}
