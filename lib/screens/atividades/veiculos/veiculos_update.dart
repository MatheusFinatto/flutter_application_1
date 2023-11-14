import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VeiculosUpdate extends StatefulWidget {
  final String empresaID;
  final String? veiculoID;
  const VeiculosUpdate({super.key, required this.empresaID, this.veiculoID});

  @override
  State<VeiculosUpdate> createState() => _VeiculosUpdateState();
}

class _VeiculosUpdateState extends State<VeiculosUpdate> {
  int capacidade = 5;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _anoController = TextEditingController();
  final TextEditingController _capacidadeController = TextEditingController();

  File? _selectedImage;

  void _updateVeiculo(String id, String marca, String modelo, String placa,
      String ano, String capacidade) {
    FirebaseFirestore db = FirebaseFirestore.instance;

    DocumentReference veiculoRef = db
        .collection("empresas")
        .doc(widget.empresaID)
        .collection("veiculos")
        .doc(widget.veiculoID);

    Map<String, dynamic> dataAtualizada = {
      "imageUrl":
          "https://s7d1.scene7.com/is/image/hyundai/compare-vehicle-1225x619?wid=276&hei=156&fmt=webp-alpha",
    };
    if (marca.isNotEmpty) {
      dataAtualizada["marca"] = marca;
    }
    if (modelo.isNotEmpty) {
      dataAtualizada["modelo"] = modelo;
    }
    if (placa.isNotEmpty) {
      dataAtualizada["placa"] = placa;
    }
    if (ano.isNotEmpty) {
      dataAtualizada["ano"] = ano;
    }
    if (capacidade.isNotEmpty) {
      dataAtualizada["capacidade"] = capacidade;
    }

    veiculoRef.update(dataAtualizada).then((value) {}).catchError((error) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Veículo"),
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
                    _updateVeiculo(
                        _idController.text,
                        _marcaController.text,
                        _modeloController.text,
                        _placaController.text,
                        _anoController.text,
                        _capacidadeController.text);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("Editar Veículo")],
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
      //_imageUrl = imagem.path.toString();
    });
  }
}
