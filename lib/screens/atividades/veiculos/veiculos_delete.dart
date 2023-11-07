import 'package:flutter/material.dart';

class VeiculosDelete extends StatefulWidget {
  const VeiculosDelete({super.key});

  @override
  State<VeiculosDelete> createState() => _VeiculosDeleteState();
}

class _VeiculosDeleteState extends State<VeiculosDelete> {
  int capacidade = 5;
  final String _imageUrl = "";

  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _anoController = TextEditingController();
  final TextEditingController _capacidadeController = TextEditingController();

  void _DeleteVeiculo(String placa) {
    // Funcão de Delete no Firebase
    imagemCarregada == Image.asset(_imageUrl);
  }

  Widget imagemCarregada = const Text("");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deletar Veículo"),
        backgroundColor: const Color.fromARGB(255, 232, 60, 60),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _placaController,
                decoration: const InputDecoration(
                  labelText: "Placa",
                ),
              ),
              TextFormField(
                controller: _marcaController,
                decoration: const InputDecoration(
                  labelText: "Marca",
                ),
                enabled: false,
              ),
              TextFormField(
                controller: _modeloController,
                decoration: const InputDecoration(
                  labelText: "Modelo",
                ),
                enabled: false,
              ),
              TextFormField(
                controller: _anoController,
                decoration: const InputDecoration(
                  labelText: "Ano",
                ),
                enabled: false,
              ),
              TextFormField(
                controller: _capacidadeController,
                decoration: const InputDecoration(
                  labelText: "Capacidade",
                ),
                enabled: false,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20.0),
              imagemCarregada,
              const SizedBox(height: 20.0), // Espaço entre os campos
              ElevatedButton(
                  onPressed: () {
                    _DeleteVeiculo(
                      _placaController.text,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 232, 60, 60)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("Deletar Veículo")],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
