import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/helpers/showErrorMessage.dart';
import 'package:flutter_application_1/helpers/showSuccessMessage.dart';
import 'package:flutter_application_1/screens/atividades/empresas/empresas.dart';
import 'package:flutter_application_1/screens/atividades/empresas/empresas_add.dart';
import 'package:flutter_application_1/screens/conta/config_screen.dart';
import 'package:flutter_application_1/screens/conta/register_page.dart';
import 'package:flutter_application_1/models/pessoas.dart';

class ContaScreen extends StatefulWidget {
  ContaScreen({Key? key}) : super(key: key);

  @override
  ContaScreenState createState() => ContaScreenState();
}

class ContaScreenState extends State<ContaScreen> {
  TextEditingController _empresaIdController = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  String nome = "",
      email = "",
      imagem = "",
      empresaId = "null",
      pessoaId = "null";

  bool _isLoading = true;

  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> getDados() async {
    Pessoa user = Pessoa(empresaId: 'null');
    Pessoa pessoa = await user.getUserSession();
    setState(() {
      nome = pessoa.nome!;
      email = pessoa.email!;
      imagem = pessoa.imageUrl!;
      empresaId = pessoa.empresaId;
      pessoaId = pessoa.id!;
    });
    _isLoading = false;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    Pessoa user = Pessoa(empresaId: 'null');
    Pessoa pessoa = await user.getUserSession();
    setState(() {
      nome = pessoa.nome!;
      email = pessoa.email!;
      imagem = pessoa.imageUrl!;
      empresaId = pessoa.empresaId;
      pessoaId = pessoa.id!;
    });
    _isLoading = false;
  }

  void deslogar() async {
    await auth.signOut().then((value) => {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => RegisterPage()),
              (route) => false)
        });
  }

  Future<DocumentSnapshot> getEmpresaData() async {
    // Replace 'collectionName' with the actual name of your Firestore collection
    DocumentSnapshot empresaSnapshot =
        await db.collection('empresas').doc(empresaId).get();

    return empresaSnapshot;
  }

  @override
  void initState() {
    super.initState();
    getDados();
  }

  Future<void> _ingressarEmpresa(context) async {
    String informedEmpresaId = _empresaIdController.text;
    FirebaseFirestore db = FirebaseFirestore.instance;

    DocumentSnapshot empresaDoc =
        await db.collection('empresas').doc(informedEmpresaId).get();

    Map<String, dynamic>? empresaData =
        empresaDoc.data() as Map<String, dynamic>?;

    if (empresaData != null) {
      await db
          .collection('pessoas')
          .doc(pessoaId)
          .update({'empresaId': informedEmpresaId});

      showSuccessMessage("Sucesso ao ingressar na empresa!", context);
    } else {
      showErrorMessage('Empresa não encontrada.', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conta'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: empresaId == 'null' ? null : getEmpresaData(),
        builder: (context, snapshot) {
          if ((snapshot.connectionState == ConnectionState.waiting) ||
              _isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          return Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 20, left: 40, top: 16, right: 40),
                child: Row(
                  // Display pessoa data
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: Image.network(
                        imagem == ''
                            ? 'https://cdn-icons-png.flaticon.com/512/149/149071.png'
                            : imagem,
                        width: 120,
                        height: 120,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 190, // Set the desired maximum width
                          child: Text(
                            nome,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          email,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListView(
                shrinkWrap: true,
                children: <Widget>[
                  if (empresaId != 'null') ...[
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Empresas(),
                          ),
                        ).then(
                          (value) => setState(
                            () {
                              getDados();
                            },
                          ),
                        );
                      },
                      leading: const Icon(Icons.corporate_fare_sharp),
                      title: const Text(
                        'Empresa',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ConfigScreen(pessoaId: pessoaId),
                          ),
                        );
                      },
                      leading: const Icon(Icons.person),
                      title: const Text(
                        'Alterar dados',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40, left: 10),
                      child: ListTile(
                        onTap: () {
                          deslogar();
                        },
                        title: const Text(
                          'Encerrar sessão',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EmpresasAdd(
                              userId: '',
                            ),
                          ),
                        ).then(
                          (value) => setState(
                            () {
                              getDados();
                            },
                          ),
                        );
                      },
                      leading: const Icon(Icons.domain_add),
                      title: const Text(
                        'Crie sua empresa',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Informe o código da empresa'),
                              content: Container(
                                height: 200.0,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextFormField(
                                        controller: _empresaIdController,
                                        decoration: const InputDecoration(
                                          labelText: 'Código da empresa',
                                        ),
                                      ),
                                      const SizedBox(height: 16.0),
                                      ElevatedButton(
                                        onPressed: () {
                                          _ingressarEmpresa(context)
                                              .then((value) => {
                                                    Navigator.popUntil(
                                                        context,
                                                        (route) =>
                                                            route.isFirst),
                                                    setState(
                                                      () {
                                                        getDados();
                                                      },
                                                    ),
                                                  });
                                          ;
                                        },
                                        child: const Text('Ingressar'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ).then(
                          (value) => setState(
                            () {
                              getDados();
                            },
                          ),
                        );
                      },
                      leading: const Icon(Icons.person),
                      title: const Text(
                        'Ingresse em uma empresa',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ConfigScreen(pessoaId: pessoaId),
                          ),
                        ).then(
                          (value) => setState(
                            () {
                              getDados();
                            },
                          ),
                        );
                      },
                      leading: const Icon(Icons.person),
                      title: const Text(
                        'Alterar dados',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40, left: 10),
                      child: ListTile(
                        onTap: () {
                          deslogar();
                        },
                        title: const Text(
                          'Encerrar sessão',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
