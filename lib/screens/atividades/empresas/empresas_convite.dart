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

  void _ingressarEmpresa(BuildContext context) async {
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore db = FirebaseFirestore.instance;

  if (user != null) {
    String userId = user.uid;
    String empresaId = _conviteController.text; // Obtém o texto do controller

    // Referência ao documento do usuário
    DocumentReference userDocRef = db.collection("pessoas").doc(userId);

    // Verifica se o empresaId existe na coleção empresas
    bool empresaExiste = await _verificarEmpresaExistente(empresaId);

    if (empresaExiste) {
      // Criação do mapa com os dados a serem atualizados
      Map<String, dynamic> data = {
        "empresaId": empresaId, // Utiliza o texto do controller
      };

      userDocRef.update(data).then((_) {
        _exibirPopUp(context, 'Sucesso ao ingressar na empresa!');
      }).catchError((error) {
        _exibirPopUp(context, 'Erro ao ingressar na empresa: $error');
      });
    } else {
      _exibirPopUp(context, 'Empresa não encontrada');
    }
  } else {
    _exibirPopUp(context, 'Usuário não logado');
  }
}

  Future<bool> _verificarEmpresaExistente(String empresaId) async {
  FirebaseFirestore db = FirebaseFirestore.instance;

  // Realiza uma consulta na coleção 'empresas' para verificar se existe um documento com o mesmo uid
  DocumentSnapshot documentSnapshot = await db.collection('empresas').doc(empresaId).get();

  return documentSnapshot.exists;
}

  void _exibirPopUp(BuildContext context, String mensagem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Status'),
          content: Text(mensagem),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
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
                    _ingressarEmpresa(context);
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
