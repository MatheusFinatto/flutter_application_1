import 'package:flutter/material.dart';

class AtividadesScreen extends StatelessWidget {
  const AtividadesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Atividades'),
      ),
      body: Column(
        children: [
          // Search input field
          Padding(
            padding: const EdgeInsets.all(16.0),
          ),
        ],
      ),
    );
  }
}
