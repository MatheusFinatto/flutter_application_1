import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/atividades/empresas/empresas.dart';
import 'package:flutter_application_1/models/pessoas.dart';

class EmpresasHome extends StatefulWidget {
  const EmpresasHome({Key? key}) : super(key: key);

  @override
  State<EmpresasHome> createState() => _EmpresasHomeState();
}

class _EmpresasHomeState extends State<EmpresasHome> {
  final List<String> empresasNomes = [];
  final List<String> empresaId = [];
  final List<String> funcionariosUid = [];

  bool _isLoading = true;

  String usuarioLogado = "";

  void _getDados() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    Pessoa user = Pessoa(empresaId: 'null');
    Pessoa pessoa = await user.getUserSession();
    setState(() {
      if (auth.currentUser != null) {
        usuarioLogado = pessoa.id!;
      }
    });
    setState(() {
      _isLoading = false;
    });
  }

  void _getEmpresas() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    QuerySnapshot empresasSnapshot = await db.collection("empresas").get();

    if (empresasSnapshot.docs.isNotEmpty) {
      empresasNomes.clear(); // Limpar a lista antes de adicionar os novos itens

      List<Future<void>> futures = [];

      for (QueryDocumentSnapshot doc in empresasSnapshot.docs) {
        var empresaData = doc.data() as Map<String, dynamic>;
        var nomeDaEmpresa = empresaData["nome"];
        var uidEmpresa = doc.id;

        var funcionariosRefs = empresaData["funcionarios"] as List<dynamic>;
        for (var funcionarioRef in funcionariosRefs) {
          DocumentReference funcionarioDocRef = funcionarioRef;
          futures.add(funcionarioDocRef.get().then((funcionarioSnapshot) {
            if (funcionarioSnapshot.exists) {
              var uidFuncionario = funcionarioSnapshot.id;
              if (uidFuncionario == usuarioLogado) {
                setState(() {
                  funcionariosUid.add(uidFuncionario);
                });
                setState(() {
                  empresasNomes.add(nomeDaEmpresa);
                });
                setState(() {
                  empresaId.add(uidEmpresa);
                });
              }
            }
          }));
        }
      }

      // Esperar até que todas as consultas sejam concluídas
      await Future.wait(futures);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getDados();
    _getEmpresas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empresas'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          if (_isLoading) const CircularProgressIndicator(),
          if (!_isLoading)
            if (empresasNomes.isEmpty)
              const Center(
                child: Text("Nenhuma empresa encontrada"),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: empresasNomes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Empresas(),
                            ),
                          );
                        },
                        child: Text(empresasNomes[index]),
                      ),
                    );
                  },
                ),
              ),
        ],
      ),
    );
  }
}
