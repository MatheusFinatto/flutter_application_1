import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/pessoas.dart';
import 'package:flutter_application_1/screens/atividades/empresas/empresas_update.dart';

class Empresas extends StatefulWidget {
  const Empresas({super.key});

  @override
  State<Empresas> createState() => _EmpresasState();
}

class _EmpresasState extends State<Empresas> {
  bool _isLoading = true;

  FirebaseFirestore db = FirebaseFirestore.instance;
  String id = "", nome = "", cpf = "", imagem = "", empresaId = "null";
  void getDados() async {
    Pessoa user = Pessoa(empresaId: 'null');
    Pessoa pessoa = await user.getUserSession();
    setState(() {
      id = pessoa.id!;
      nome = pessoa.nome!;
      cpf = pessoa.cpf!;
      imagem = pessoa.imageUrl!;
      empresaId = pessoa.empresaId;
    });
    _getEmpresaData(empresaId);
    _isLoading = false;
  }

  String _empresaId = "";
  String _empresaNome = "";
  String _empresaCNPJ = "";
  String _empresaEndereco = "";
  String _empresaTelefone = "";
  String _empresaEmail = "";

  _getEmpresaData(empresaId) async {
    DocumentSnapshot snapshot =
        await db.collection("empresas").doc(empresaId).get();

    setState(() {
      if (snapshot.data() != null) {
        final data = snapshot.data() as Map<String, dynamic>;

        _empresaId = snapshot.id;

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
  }

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    getDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dados da empresa")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  const Text(
                    'Código da empresa: ',
                    style: TextStyle(fontSize: 25),
                  ),
                  Text(
                    '$_empresaId',
                    style: const TextStyle(fontSize: 20),
                  )
                ]),
              ),
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
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirmação de saída'),
                        content: const Text(
                            'Tem certeza de que deseja sair da empresa?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancelar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Sair'),
                            onPressed: () async {
                              FirebaseFirestore db = FirebaseFirestore.instance;

                              await db
                                  .collection('pessoas')
                                  .doc(id)
                                  .update({'empresaId': 'null'});

                              // getDados();

                              // Navigate back twice
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
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
                    Text('Sair da empresa'),
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
