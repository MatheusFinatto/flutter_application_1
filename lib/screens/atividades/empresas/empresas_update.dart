import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EmpresasUpdate extends StatefulWidget {
  final String empresaId;
  const EmpresasUpdate({super.key, required this.empresaId});
  @override
  State<EmpresasUpdate> createState() => _EmpresasUpdateState();
}

class _EmpresasUpdateState extends State<EmpresasUpdate> {
  final TextEditingController _cnpjController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _updateEmpresa(String cnpj, String nome, String endereco,
      String telefone, String email) {
    FirebaseFirestore db = FirebaseFirestore.instance;

    DocumentReference empresaRef =
        db.collection("empresas").doc(widget.empresaId);

    Map<String, dynamic> dataAtualizada = {};
    if (cnpj.isNotEmpty) {
      dataAtualizada["cnpj"] = cnpj;
    }

    if (nome.isNotEmpty) {
      dataAtualizada["nome"] = nome;
    }

    if (endereco.isNotEmpty) {
      dataAtualizada["endereco"] = endereco;
    }

    if (telefone.isNotEmpty) {
      dataAtualizada["telefone"] = telefone;
    }

    if (email.isNotEmpty) {
      dataAtualizada["email"] = email;
    }

    empresaRef.update(dataAtualizada).then((value) {}).catchError((error) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Atualizar Empresa"),
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
                    _updateEmpresa(
                        _cnpjController.text,
                        _nomeController.text,
                        _enderecoController.text,
                        _telefoneController.text,
                        _emailController.text);

                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("Atualizar Empresa")],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
