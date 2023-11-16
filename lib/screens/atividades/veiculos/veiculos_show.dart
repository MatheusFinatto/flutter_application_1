import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/pessoas.dart';
import 'package:flutter_application_1/screens/atividades/veiculos/veiculos_add.dart';
import 'package:flutter_application_1/screens/atividades/veiculos/veiculos_update.dart';

class VeiculosShow extends StatefulWidget {
  const VeiculosShow({super.key});

  @override
  State<VeiculosShow> createState() => _VeiculosShowState();
}

class _VeiculosShowState extends State<VeiculosShow> {
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

  @override
  void initState() {
    super.initState();
    getDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Veículos Cadastrados")),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('empresas')
                    .doc(empresaId)
                    .collection('veiculos')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text("Nenhum veículo cadastrado!"));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      final veiculoData = snapshot.data?.docs[index].data()
                          as Map<String, dynamic>;

                      final veiculoID = snapshot.data?.docs[index].id;
                      print('veiculoID $veiculoID');
                      return ListTile(
                        subtitle: Column(
                          children: [
                            const SizedBox(height: 16),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.network(
                                      veiculoData['imageUrl'] as String? ??
                                          'https://i.imgur.com/BVD0UE8.png',
                                      width: MediaQuery.of(context).size.width,
                                      height: 200,
                                    ),
                                    const SizedBox(height: 16),
                                    Text("Marca: ${veiculoData['marca']}"),
                                    Text("Modelo: ${veiculoData['modelo']}"),
                                    Text("Placa: ${veiculoData['placa']}"),
                                    Text("Ano: ${veiculoData['ano']}"),
                                    Text(
                                        "Capacidade: ${veiculoData['capacidade']} pessoas"),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        buildEditButton(veiculoID),
                                        buildDeleteButton(context, veiculoID),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          // Botão de adição no final da lista
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VeiculosAdd(
                empresaID: empresaId,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildEditButton(veiculoID) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VeiculosUpdate(
                empresaID: empresaId,
                veiculoID: veiculoID,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 60, 141, 130),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Editar'),
            SizedBox(width: 2),
            Icon(Icons.edit, size: 14),
          ],
        ),
      ),
    );
  }

  Widget buildDeleteButton(BuildContext context, veiculoID) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmação de Exclusão'),
              content:
                  const Text('Tem certeza de que deseja excluir este item?'),
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
                    DocumentReference veiculosRef = db
                        .collection("empresas")
                        .doc(empresaId)
                        .collection("veiculos")
                        .doc(veiculoID);
                    veiculosRef.delete();
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
          Text('Excluir'),
          SizedBox(width: 2),
          Icon(Icons.delete, size: 14),
        ],
      ),
    );
  }
}
