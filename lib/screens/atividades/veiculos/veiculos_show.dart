import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/screens/atividades/veiculos/veiculos_add.dart';
import 'package:flutter_application_1/screens/atividades/veiculos/veiculos_update.dart';

class VeiculosShow extends StatefulWidget {
  final String empresaId;
  const VeiculosShow({super.key, required this.empresaId});

  @override
  State<VeiculosShow> createState() => _VeiculosShowState();
}

class _VeiculosShowState extends State<VeiculosShow> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String? veiculoID = "";

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
                    .doc(widget.empresaId)
                    .collection('veiculos')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Mostrar um indicador de carregamento enquanto aguarda os dados.
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text(
                      "Nenhum veículo encontrado.",
                      style: TextStyle(fontSize: 16),
                    ); // Exibir uma mensagem se não houver veículos.
                  }

                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      final veiculoData = snapshot.data?.docs[index].data()
                          as Map<String, dynamic>;
                      veiculoID = snapshot.data?.docs[index].id;
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
                                          'https://s7d1.scene7.com/is/image/hyundai/compare-veiculo-1225x619?wid=600&fmt=webp',
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
                                        buildEditButton(),
                                        buildDeleteButton(context),
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
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VeiculosAdd(
                                empresaID: widget.empresaId,
                              )));
                },
                child: const Icon(Icons.add)),
          ),
        ],
      ),
    );
  }

  Widget buildEditButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VeiculosUpdate(
                        empresaID: widget.empresaId,
                        veiculoID: veiculoID,
                      )));
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

  Widget buildDeleteButton(BuildContext context) {
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
                        .doc(widget.empresaId)
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
