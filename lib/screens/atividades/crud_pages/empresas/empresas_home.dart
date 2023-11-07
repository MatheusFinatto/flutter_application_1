import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'empresas_add.dart';
import 'package:flutter_application_1/screens/atividades/empresas.dart';

class EmpresasHome extends StatefulWidget {
  const EmpresasHome({Key? key}) : super(key: key);

  @override
  State<EmpresasHome> createState() => _EmpresasHomeState();
}

class _EmpresasHomeState extends State<EmpresasHome> {
  final List<String> empresasNomes = [];
  final List<String> empresasUid = [];
  final List<String> funcionariosUid = [];

  void _getEmpresas() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    var usuarioLogado = "u4pQs7xwvuVovg8rC6DH";

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
              var nomeFuncionario = funcionarioSnapshot["nome"];
              var uidFuncionario = funcionarioSnapshot.id;
              if (uidFuncionario == usuarioLogado) {
                setState(() {
                  funcionariosUid.add(uidFuncionario);
                });
                setState(() {
                  empresasNomes.add(nomeDaEmpresa);
                });
                setState(() {
                  empresasUid.add(uidEmpresa);
                });
              }
            }
          }));
        }
      }

      // Esperar até que todas as consultas sejam concluídas
      await Future.wait(futures);
    }
  }

  @override
  void initState() {
    super.initState();
    _getEmpresas(); // Chama a função ao entrar na tela
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empresas'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
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
                          builder: (context) =>
                              Empresas(empresaUid: empresasUid[index],),
                        ),
                      );
                    },
                    child: Text(empresasNomes[index]),
                  ),
                );
              },
            ),
          ),
        SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => EmpresasAdd()));
          }, child: Icon(Icons.add)),
        )
        ],
      ),
    );
  }
}
