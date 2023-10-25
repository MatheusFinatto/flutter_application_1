import 'package:flutter/material.dart';

class EmpresasDelete extends StatefulWidget {
  const EmpresasDelete({super.key});

  @override
  State<EmpresasDelete> createState() => _EmpresasDeleteState();
}

class _EmpresasDeleteState extends State<EmpresasDelete> {
  String _id = "0";
  String _cnpj = "";
  String _nome = "";
  String _enderecoMatriz = "";
  String _telefone = "";
  String _email = "";

  TextEditingController _idController = TextEditingController();
  TextEditingController _cnpjController = TextEditingController();
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _enderecoController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  void _deleteEmpresa(String cnpj) {
        // Funcão para Deletar a Empresa no banco
      }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deletar Empresa"),
        backgroundColor: const Color.fromARGB(255, 232, 60, 60),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _cnpjController,
                decoration: const InputDecoration(
                  labelText: "CNPJ",
                ),
              ),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: "Nome da Empresa",
                ),
                enabled: false,
              ),
              TextFormField(
                controller: _enderecoController,
                decoration: const InputDecoration(
                  labelText: "Endereço",
                ),
                enabled: false,
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(
                  labelText: "Telefone",
                ),
                enabled: false,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                ),
                enabled: false,
              ),
              const SizedBox(height: 20), // Espaço entre os campos
              ElevatedButton(
                  onPressed: () {
                    _deleteEmpresa(
                        _cnpjController.text);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 232, 60, 60)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("Deletar Empresa")],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
