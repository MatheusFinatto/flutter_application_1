import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/screens/atividades/crud_pages/empresas/empresas_update.dart';

class Empresas extends StatefulWidget {
  final String empresaUid;

  Empresas({required this.empresaUid});

  @override
  State<Empresas> createState() => _EmpresasState();
}

class _EmpresasState extends State<Empresas> {
  bool _isLoading = true;
  FirebaseFirestore db = FirebaseFirestore.instance;

  String _empresaNome = "";
  String _empresaCNPJ = "";
  String _empresaEndereco = "";
  String _empresaTelefone = "";
  String _empresaEmail = "";

  _getEmpresaData() async {
    DocumentSnapshot snapshot =
        await db.collection("empresas").doc(widget.empresaUid).get();

    setState(() {
      if (snapshot.data() != null) {
        final data = snapshot.data() as Map<String, dynamic>;

        if (data["nome"] != null) {
          _empresaNome = data["nome"];
        }
        if (data["cnpj"] != null) {
          _empresaCNPJ = data["cnpj"];
        }
        if (data["enderecoMatriz"] != null) {
          _empresaEndereco = data["enderecoMatriz"];
        }
        if (data["telefone"] != null) {
          _empresaTelefone = data["telefone"];
        }
        if (data["email"] != null) {
          _empresaEmail = data["email"];
        }
      }
    });

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getEmpresaData(); // Chama a função ao entrar na tela
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_empresaNome)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Center(
                    child: Text(
                      _empresaNome,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EmpresasUpdate()));
                      },
                      child: const Row(children: [
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            "Editar empresa",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Icon(Icons.edit),
                      ]),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading) CircularProgressIndicator(),
                if (!_isLoading)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (_empresaCNPJ !=
                          null) // Verifique se o campo cnpj existe
                        Text(
                          'CNPJ: $_empresaCNPJ',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                      if (_empresaEndereco !=
                          null) // Verifique se o campo enderecoMatriz existe
                        Text(
                          'Endereço Matriz: $_empresaEndereco',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                      if (_empresaTelefone !=
                          null) // Verifique se o campo telefone existe
                        Text(
                          'Telefone: $_empresaTelefone',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                      if (_empresaEmail !=
                          null) // Verifique se o campo email existe
                        Text(
                          'Email: $_empresaEmail',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20),
                    ],
                  ),
                  ElevatedButton(onPressed: (){}, child: Container(
                    child: Text("Veículos da Empresa"),
                  ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
