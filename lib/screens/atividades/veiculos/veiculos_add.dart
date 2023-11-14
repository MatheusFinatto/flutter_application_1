import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VeiculosAdd extends StatefulWidget {
  final String empresaID;
  const VeiculosAdd({super.key, required this.empresaID});

  @override
  State<VeiculosAdd> createState() => _VeiculosAddState();
}

class _VeiculosAddState extends State<VeiculosAdd> {
  int capacidade = 0;

  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _anoController = TextEditingController();
  final TextEditingController _capacidadeController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  File? _selectedImage;

  void _addVeiculo(String marca, String modelo, String placa, String ano,
      int capacidade, String imageUrl) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    db.collection("empresas").doc(widget.empresaID).collection("veiculos").add({
      "marca": marca,
      "modelo": modelo,
      "placa": placa,
      "ano": ano,
      "capacidade": capacidade,
      "imageUrl": imageUrl != '' ? imageUrl : "https://i.imgur.com/BVD0UE8.png",
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Criar Veículo"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _marcaController,
                decoration: const InputDecoration(
                  labelText: "Marca",
                ),
              ),
              TextFormField(
                controller: _modeloController,
                decoration: const InputDecoration(
                  labelText: "Modelo",
                ),
              ),
              TextFormField(
                controller: _placaController,
                decoration: const InputDecoration(
                  labelText: "Placa",
                ),
              ),

              TextFormField(
                controller: _anoController,
                decoration: const InputDecoration(
                  labelText: "Ano",
                ),
              ),
              TextFormField(
                controller: _capacidadeController,
                decoration: const InputDecoration(
                  labelText: "Capacidade",
                ),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: "URL da foto",
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: () {
                  _pickImageFromGallery();
                },
                child: const Row(
                  children: [Text("Selecionar Imagem")],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              _selectedImage != null
                  ? Image.file(_selectedImage!)
                  : const Text("Por favor selecione uma imagem."),
              const SizedBox(height: 40), // Espaço entre os campos
              ElevatedButton(
                  onPressed: () {
                    int capacidade = int.parse(_capacidadeController.text);

                    _addVeiculo(
                        _marcaController.text,
                        _modeloController.text,
                        _placaController.text,
                        _anoController.text,
                        capacidade,
                        _imageUrlController.text);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("Criar Veículo")],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future _pickImageFromGallery() async {
    final imagem = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (imagem == null) return;
    setState(() {
      _selectedImage = File(imagem.path);
    });
  }
}
