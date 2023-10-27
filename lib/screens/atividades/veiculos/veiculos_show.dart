import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VeiculosShow extends StatefulWidget {
  const VeiculosShow({super.key});

  @override
  State<VeiculosShow> createState() => _VeiculosShowState();
}

class _VeiculosShowState extends State<VeiculosShow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Veículos Cadastrados")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('empresas')
            .doc('UywGfjmMyYNRHFyx5hUN')
            .collection('veiculos')
            .snapshots(),
        builder: (context, snapshot) {
          print(snapshot.data!.docs[0].data());
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show a loading indicator while waiting for data.
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Text(
                "No veiculos found."); // Display a message if there are no veiculos.
          }

          if (snapshot.data!.docs.length > 0) {
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                final veiculoData =
                    snapshot.data?.docs[index].data() as Map<String, dynamic>;

                return ListTile(
                  subtitle: Column(
                    children: [
                      SizedBox(height: 16),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              // Replace 'imageUrl' with the actual field name in your Firestore document
                              Image.network(
                                veiculoData['imageUrl'] as String? ??
                                    'https://s7d1.scene7.com/is/image/hyundai/compare-vehicle-1225x619?wid=600&fmt=webp',
                                width: MediaQuery.of(context).size.width,
                                height: 200,
                              ),
                              SizedBox(height: 16),
                              Text("Marca: ${veiculoData['marca']}"),
                              Text("Modelo: ${veiculoData['modelo']}"),
                              Text("Placa: ${veiculoData['placa']}"),
                              Text("Ano: ${veiculoData['ano']}"),
                              Text(
                                  "Capacidade: ${veiculoData['capacidade']} pessoas"),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 20, 10, 20),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Add your edit logic here
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 60, 141, 130),
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
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Add your delete logic here
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
                                  ),
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
          }
          return Placeholder();
        },
      ),
    );
  }
}
