import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/conta/conta_screen.dart';
import 'package:image_picker/image_picker.dart';


class ConfigScreen extends StatefulWidget {
  final String pessoaId;
  const ConfigScreen({Key? key, required this.pessoaId}) : super(key: key);

  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _imgUrlController = TextEditingController();
  
  void _updatePessoa(
    String nome,
    String cpf,
    String endereco,
    String telefone,
    String imageUrl,
  ) {
    FirebaseFirestore db = FirebaseFirestore.instance;

    DocumentReference pessoaRef =
        db.collection("pessoas").doc(widget.pessoaId);

    Map<String, dynamic> dataAtualizada = {};
    if (nome.isNotEmpty) {
      dataAtualizada["nome"] = nome;
    }

    if (cpf.isNotEmpty) {
      dataAtualizada["cpf"] = cpf;
    }

    if (endereco.isNotEmpty) {
      dataAtualizada["endereco"] = endereco;
    }

    if (telefone.isNotEmpty) {
      dataAtualizada["telefone"] = telefone;
    }

      if (imageUrl.isNotEmpty) {
      dataAtualizada["imageUrl"] = imageUrl;
    }

    pessoaRef.update(dataAtualizada).then((value) {
    }).catchError((error) {});
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
                controller: _cpfController,
                decoration: const InputDecoration(
                  labelText: "CPF",
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
                controller: _imgUrlController,
                decoration: const InputDecoration(
                  labelText: "Image de perfil",
                ),
              ),
        
              ElevatedButton(
                onPressed: () {
                  _updatePessoa(
                    _nomeController.text,
                    _cpfController.text,
                    _enderecoController.text,
                    _telefoneController.text,
                    _imgUrlController.text
                  );
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


