import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_1/helpers/showErrorMessage.dart';
import 'package:flutter_application_1/helpers/showSuccessMessage.dart';
import 'package:flutter_application_1/models/pessoas.dart';
import 'package:flutter_application_1/screens/conta/conta_screen.dart';

class EmpresasAdd extends StatefulWidget {
  final String userId;
  const EmpresasAdd({super.key, required this.userId});
  @override
  State<EmpresasAdd> createState() => _EmpresasAddState();
}

class _EmpresasAddState extends State<EmpresasAdd> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String id = "", nome = "", email = "", imagem = "", empresaId = "null";

  FirebaseAuth auth = FirebaseAuth.instance;
  void getDados() async {
    Pessoa user = Pessoa(empresaId: 'null');
    Pessoa pessoa = await user.getUserSession();
    setState(() {
      id = pessoa.id!;
      nome = pessoa.nome!;
      email = pessoa.email!;
      imagem = pessoa.imageUrl!;
      empresaId = pessoa.empresaId;
    });
    print('id $id');
  }

  @override
  void initState() {
    super.initState();
    getDados();
  }

  final TextEditingController _cnpjController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;

  void _createEmpresa(String cnpj, String nome, String endereco,
      String telefone, String email, String userId) async {
    if (cnpj.length < 14) {
      showErrorMessage('Por favor, insira um CNPJ válido.', context);
    } else if (nome.isEmpty) {
      showErrorMessage('Por favor, insira um nome para a empresa.', context);
    } else {
      FirebaseFirestore db = FirebaseFirestore.instance;

      // Add the empresa to the "empresas" collection and get the DocumentReference
      DocumentReference empresaRef = await db.collection("empresas").add({
        "nome": nome,
        "cnpj": cnpj,
        "enderecoMatriz": endereco,
        "telefone": telefone,
        "email": email,
      });

      await db.collection("pessoas").doc(userId).update({
        "empresaId": empresaRef.id,
      });
      // Delay the navigation to ContaScreen by scheduling the callback after the current frame
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        _isLoading = false;

        Navigator.pop(context, true);
        // Show the success message after the navigation
        showSuccessMessage('Empresa criada com sucesso!', context);
      });
      _isLoading = false;
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
                          id);
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
