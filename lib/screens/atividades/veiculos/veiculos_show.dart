import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/veiculos.dart';
import 'package:flutter_application_1/screens/atividades/veiculos/veiculos_update.dart';

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
      body: Container(
        width: MediaQuery.of(context)
            .size
            .width, // Set the width to match screen width
        child: ListView.builder(
          itemCount: veiculosList.length,
          itemBuilder: (context, index) {
            return ListTile(
              subtitle: Column(
                children: [
                  SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Image.asset(
                            veiculosList[index].imageUrl,
                            width: MediaQuery.of(context)
                                .size
                                .width, // Set image width to match screen width
                            height: 200,
                          ),
                          Text("Marca: ${veiculosList[index].marca}"),
                          Text("Modelo: ${veiculosList[index].modelo}"),
                          Text("Placa: ${veiculosList[index].placa}"),
                          Text("Ano: ${veiculosList[index].ano}"),
                          Text(
                              "Capacidade: ${veiculosList[index].capacidade} pessoas"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 20, 10, 20),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => VeiculosUpdate(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 60, 141, 130),
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
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors
                                      .red, // Change the button's background color
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        'Excluir'), // Change the text to "Excluir" (Delete in Portuguese)
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
        ),
      ),
    );
  }
}
