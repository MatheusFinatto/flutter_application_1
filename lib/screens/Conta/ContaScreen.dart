import 'package:flutter/material.dart';

class ContaScreen extends StatelessWidget {
  const ContaScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conta'),
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
