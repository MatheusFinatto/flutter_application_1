import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmpresaConvite extends StatefulWidget {
  const EmpresaConvite({super.key});

  @override
  State<EmpresaConvite> createState() => _EmpresaConviteState();
}

class _EmpresaConviteState extends State<EmpresaConvite> {
  TextEditingController _conviteController = new TextEditingController();

  void _ingressarEmpresa() {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore db = FirebaseFirestore.instance;
    if (user != null) {
      String userId = user.uid;
      DocumentReference ref = db.collection("pessoas").doc("$userId");
      ref.set("empresaId: $_conviteController");

      // Aqui você pode fazer algo com userId e idDaEmpresa, como salvar no banco de dados, etc.
    } else {
      // Usuário não autenticado, talvez exibir uma mensagem de erro
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ingressar na Empresa"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _conviteController,
                decoration: const InputDecoration(
                  labelText: "ID da empresa",
                ),
              ),
              const SizedBox(height: 20), // Espaço entre os campos
              ElevatedButton(
                  onPressed: () {
                    _ingressarEmpresa();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("Ingressar na Empresa")],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
