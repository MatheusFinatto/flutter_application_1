import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmpresasAdd extends StatefulWidget {
  const EmpresasAdd({super.key});

  @override
  State<EmpresasAdd> createState() => _EmpresasAddState();
}

class _EmpresasAddState extends State<EmpresasAdd> {
  String _cnpj = "";
  String _nome = "";
  String _enderecoMatriz = "";
  String _telefone = "";
  String _email = "";

  TextEditingController _cnpjController = TextEditingController();
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _enderecoController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;

  void _createEmpresa(String cnpj, String nome, String endereco,
      String telefone, String email) async {
    if ((cnpj.length >= 14) && (nome.isNotEmpty)) {
      FirebaseFirestore db = FirebaseFirestore.instance;
      var data = {
        "nome": nome,
        "cnpj": cnpj,
        "endereco": endereco,
        "telefone": telefone,
        "email": email
        
      };
      await db.collection("empresas").add(data);
    }
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Criar Empresa"),
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
              if (_isLoading) const CircularProgressIndicator(),
              if (!_isLoading)
                ElevatedButton(
                    onPressed: () {
                      _isLoading = true;
                      _createEmpresa(
                          _cnpjController.text,
                          _nomeController.text,
                          _enderecoController.text,
                          _telefoneController.text,
                          _emailController.text);
                    },
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
