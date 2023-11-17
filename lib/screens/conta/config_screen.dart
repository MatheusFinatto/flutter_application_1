import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_1/helpers/showSuccessMessage.dart';
import 'package:flutter_application_1/models/pessoas.dart';

class ConfigScreen extends StatefulWidget {
  final String pessoaId;
  const ConfigScreen({Key? key, required this.pessoaId}) : super(key: key);

  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _imgUrlController = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;
  String nome = "", email = "", imagem = "";

  void getDados() async {
    Pessoa user = Pessoa(empresaId: 'null');
    Pessoa pessoa = await user.getUserSession();
    setState(() {
      _nomeController.text = pessoa.nome ?? "";
      _emailController.text = pessoa.email ?? "";
      _imgUrlController.text = pessoa.imageUrl ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    getDados();
  }

  void _updatePessoa(
    String nome,
    String email,
    String imageUrl,
  ) {
    FirebaseFirestore db = FirebaseFirestore.instance;

    DocumentReference pessoaRef = db.collection("pessoas").doc(widget.pessoaId);

    Map<String, dynamic> dataAtualizada = {};
    if (nome.isNotEmpty) {
      dataAtualizada["nome"] = nome;
    }

    if (email.isNotEmpty) {
      dataAtualizada["email"] = email;
    }

    if (imageUrl.isNotEmpty) {
      dataAtualizada["imageUrl"] = imageUrl;
    }

    pessoaRef.update(dataAtualizada).then((value) {}).catchError((error) {});

    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context, true);
      showSuccessMessage('Usuário alterado com sucesso!', context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Pessoa"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: "Nome",
                ),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                ),
              ),
              TextFormField(
                controller: _imgUrlController,
                decoration: const InputDecoration(
                  labelText: "Imagem de perfil",
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _updatePessoa(_nomeController.text, _emailController.text,
                      _imgUrlController.text);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("Salvar")],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
