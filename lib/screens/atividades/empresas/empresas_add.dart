import 'package:flutter/material.dart';

class EmpresasAdd extends StatefulWidget {
  const EmpresasAdd({super.key});

  @override
  State<EmpresasAdd> createState() => _EmpresasAddState();
}

class _EmpresasAddState extends State<EmpresasAdd> {
  // o id vai vir do proximo id do firebase, por enquanto é só um mock
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

  void _createEmpresa(String cnpj, String nome, String endereco,
      String telefone, String email) {
        // Funcão para criar a Empresa no banco
      }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Criar Empresa"),
        backgroundColor: const Color.fromARGB(255, 83, 245, 159),
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
              ),
              TextFormField(
                controller: _enderecoController,
                decoration: const InputDecoration(
                  labelText: "Endereço",
                ),
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(
                  labelText: "Telefone",
                ),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                ),
              ),
              const SizedBox(height: 20), // Espaço entre os campos
              ElevatedButton(
                  onPressed: () {
                    _createEmpresa(
                        _cnpjController.text,
                        _nomeController.text,
                        _enderecoController.text,
                        _telefoneController.text,
                        _emailController.text);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 83, 245, 159)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("Criar Empresa")],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
