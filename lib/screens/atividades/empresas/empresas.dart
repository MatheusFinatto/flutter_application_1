import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/pessoas.dart';
import 'package:flutter_application_1/screens/atividades/empresas/empresas_update.dart';
import 'package:flutter_application_1/screens/atividades/veiculos/veiculos_show.dart';

class Empresas extends StatefulWidget {
  final String empresaId;

  const Empresas({super.key, required this.empresaId});

  @override
  State<Empresas> createState() => _EmpresasState();
}

class _EmpresasState extends State<Empresas> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String nome = "", cpf = "", imagem = "", empresaId = "null";
  void getDados() async {
    Pessoa user = Pessoa(empresaId: 'null');
    Pessoa pessoa = await user.getUserSession();
    setState(() {
      nome = pessoa.nome!;
      cpf = pessoa.cpf!;
      imagem = pessoa.imageUrl!;
      empresaId = pessoa.empresaId;
      print('empresaId $empresaId');
    });
  }

  bool _isLoading = true;

  String _empresaNome = "";
  String _empresaCNPJ = "";
  String _empresaEndereco = "";
  String _empresaTelefone = "";
  String _empresaEmail = "";

  _getEmpresaData() async {
    DocumentSnapshot snapshot =
        await db.collection("empresas").doc(empresaId).get();

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

    @override
    void initState() {
      super.initState();
      getDados();
      _getEmpresaData();
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_empresaNome)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: SingleChildScrollView(
                  child: Text(
                    _empresaNome,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(
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
                              builder: (context) => EmpresasUpdate(
                                    empresaId: empresaId,
                                  )));
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
              const SizedBox(
                height: 20,
              ),
              if (_isLoading) const CircularProgressIndicator(),
              if (!_isLoading)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Verifique se o campo cnpj existe
                    Text(
                      'CNPJ: $_empresaCNPJ',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    // Verifique se o campo enderecoMatriz existe
                    SingleChildScrollView(
                      child: Text(
                        'Endereço: $_empresaEndereco',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Verifique se o campo telefone existe
                    Text(
                      'Telefone: $_empresaTelefone',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    // Verifique se o campo email existe
                    Text(
                      'Email: $_empresaEmail',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VeiculosShow(),
                      ),
                    );
                  },
                  child: const Text("Veículos da Empresa")),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirmação de Exclusão'),
                        content: const Text(
                            'Tem certeza de que deseja excluir este item?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancelar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Excluir'),
                            onPressed: () {
                              FirebaseFirestore db = FirebaseFirestore.instance;
                              DocumentReference empresasRef =
                                  db.collection("empresas").doc(empresaId);
                              empresasRef.delete();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Excluir Empresa'),
                    SizedBox(width: 2),
                    Icon(Icons.delete, size: 14),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
