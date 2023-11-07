import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmpresasAdd extends StatefulWidget {
  final String userId;
  const EmpresasAdd({super.key, required this.userId});
  @override
  State<EmpresasAdd> createState() => _EmpresasAddState();
}

class _EmpresasAddState extends State<EmpresasAdd> {

  final TextEditingController _cnpjController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;
  

  void _createEmpresa(String cnpj, String nome, String endereco,
      String telefone, String email, String userId) async {
    if ((cnpj.length >= 14) && (nome.isNotEmpty)) {
      FirebaseFirestore db = FirebaseFirestore.instance;

      DocumentReference empresaRef = db.collection("pessoas").doc(userId);

      var data = {
        "nome": nome,
        "cnpj": cnpj,
        "enderecoMatriz": endereco,
        "telefone": telefone,
        "email": email,
        "funcionarios": [empresaRef]
      };
      await db.collection("empresas").add(data);

      CollectionReference veiculosRef = empresaRef.collection("veiculos");

      veiculosRef.add({
      "marca": "",
      "modelo": "",
      // Adicione outros campos do veículo
    });
      
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
                          _emailController.text,
                          widget.userId);
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
