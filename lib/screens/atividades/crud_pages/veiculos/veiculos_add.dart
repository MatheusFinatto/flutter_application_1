import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/pessoas.dart';
import 'package:image_picker/image_picker.dart';

class VeiculosAdd extends StatefulWidget {
  const VeiculosAdd({super.key});

  @override
  State<VeiculosAdd> createState() => _VeiculosAddState();
}

class _VeiculosAddState extends State<VeiculosAdd> {
  String _id = "1";
  String _marca = "";
  String _modelo = "";
  String _placa = "";
  String _ano = "";
  int capacidade = 5;
  String _imageUrl = "";

  TextEditingController _idController = TextEditingController();
  TextEditingController _marcaController = TextEditingController();
  TextEditingController _modeloController = TextEditingController();
  TextEditingController _placaController = TextEditingController();
  TextEditingController _anoController = TextEditingController();
  TextEditingController _capacidadeController = TextEditingController();

  ImagePicker _picker = new ImagePicker();

  File? _selectedImage;


  void _addVeiculo(String id, String marca, String modelo, String placa,
      String ano, int capacidade) {
    // Funcão de Add no Firebase
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Criar Veículo"),
        backgroundColor: const Color.fromARGB(255, 83, 245, 159),
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
              const SizedBox(height: 20.0,),
              ElevatedButton(
                onPressed: () {
                  _pickImageFromGallery();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 83, 245, 159)),
                child:  const Row(
                  children: [Text("Selecionar Imagem")],
                ),
              ),
              const SizedBox(height: 20.0,),
              _selectedImage != null ? Image.file(_selectedImage!) : const Text("Por favor selecione uma imagem."),
              const SizedBox(height: 40), // Espaço entre os campos
              ElevatedButton(
                  onPressed: () {
                    _addVeiculo(
                        _idController.text,
                        _marcaController.text,
                        _modeloController.text,
                        _placaController.text,
                        _anoController.text,
                        int.parse(_capacidadeController.text)
                        );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 83, 245, 159)),
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

    if(imagem == null) return;
    setState(() {
      _selectedImage = File(imagem.path);
      _imageUrl = imagem.path.toString();
      print(_imageUrl);
    });
  }
}
