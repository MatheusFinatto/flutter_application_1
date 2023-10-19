import 'package:flutter/material.dart';

class ContaScreen extends StatelessWidget {
  const ContaScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conta'),
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
