import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/pessoas.dart';
import 'package:flutter_application_1/database/viagens.dart';
import 'package:flutter_application_1/models/viagens.dart';
import 'package:flutter_application_1/screens/viagens/widgets/buttons/delete_trip_button.dart';
import 'package:flutter_application_1/screens/viagens/widgets/buttons/edit_trip_button.dart';
import 'package:flutter_application_1/screens/viagens/add_trip_form.dart';

class ViagensScreen extends StatefulWidget {
  const ViagensScreen({Key? key}) : super(key: key);

  @override
  ViagensScreenState createState() => ViagensScreenState();
}

class ViagensScreenState extends State<ViagensScreen> {
  final TextEditingController _searchController = TextEditingController();
  final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');
  String currentUser = pessoasList[2].nome;
  late List<Trip> filteredViagens;
  late List<bool> isParticipatingList;

  @override
  void initState() {
    super.initState();
    filteredViagens = List.from(viagensList);
    isParticipatingList =
        List.generate(filteredViagens.length, (index) => false);
  }

  void onPressedButton(int index) {
    setState(() {
      isParticipatingList[index] = !isParticipatingList[index];
    });

    if (filteredViagens[index].veiculo.capacidade -
            filteredViagens[index].participantes.length <=
        0) {
      // veiculo is full; you can display a message or do nothing
      return;
    }

    if (filteredViagens[index].veiculo.capacidade -
            filteredViagens[index].participantes.length <=
        0) {
      return;
    } else if (isParticipatingList[index]) {
      filteredViagens[index].participantes.add(pessoasList[1]);
    } else {
      filteredViagens[index].participantes.removeLast();
    }

    SnackBar snackBar = SnackBar(
      content: Text(isParticipatingList[index]
          ? "Pedido para participação enviado com sucesso!"
          : "Pedido de participação cancelado!"),
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void filterTrips(String query) {
    setState(() {
      filteredViagens = viagensList.where((trip) {
        return trip.cidadeDestino.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir viagem'),
          content: const Text('Tem certeza que deseja excluir esta viagem?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                viagensList.removeAt(index);
                Navigator.of(context).pop();
                setState(() {
                  filteredViagens = List.from(viagensList);
                });
                SnackBar snackBar = const SnackBar(
                  content: Text("Viagem excluída com sucesso!"),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Viagens'),
      ),
      body: Column(
        children: [
          // Search input field
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar por destino',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                ),
              ),
              onChanged: (query) {
                setState(() {
                  filterTrips(query);
                });
              },
            ),
          ),
          // List of trips
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('empresas')
                  .doc('UywGfjmMyYNRHFyx5hUN')
                  .collection('viagens')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text("No viagens found.");
                }

                return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    final viagemData = snapshot.data?.docs[index].data()
                        as Map<String, dynamic>;

                    // Fetch and convert the 'veiculo' document reference
                    DocumentReference? veiculoReference =
                        viagemData['veiculo'] as DocumentReference?;

                    DocumentReference? responsavelReference =
                        viagemData['responsavel'] as DocumentReference?;

                    List<DocumentReference>? participantesReference = [];
                    if (viagemData['participantes'] != null) {}

                    if (veiculoReference != null ||
                        responsavelReference != null ||
                        participantesReference.isNotEmpty) {
                      return FutureBuilder<DocumentSnapshot>(
                        future: veiculoReference?.get(),
                        builder: (context, veiculoSnapshot) {
                          if (veiculoSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          if (!veiculoSnapshot.hasData ||
                              !veiculoSnapshot.data!.exists) {
                            return const Text("No veiculo found.");
                          }

                          final veiculoData = veiculoSnapshot.data!.data()
                              as Map<String, dynamic>;

                          return FutureBuilder<DocumentSnapshot>(
                            future: responsavelReference?.get(),
                            builder: (context, responsavelSnapshot) {
                              if (responsavelSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }

                              if (!responsavelSnapshot.hasData ||
                                  !responsavelSnapshot.data!.exists) {
                                return const Text("No responsavel found.");
                              }

                              // Fetch and convert participantes data
                              final futureList = participantesReference
                                  .map((reference) => reference.get())
                                  .toList();

                              return FutureBuilder<List<DocumentSnapshot>>(
                                future: Future.wait(futureList),
                                builder: (context, participantesSnapshots) {
                                  if (participantesSnapshots.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }

                                  if (!participantesSnapshots.hasData) {
                                    return const Text(
                                        "No participantes found.");
                                  }

                                  // Get the data for each participant
                                  for (DocumentSnapshot snapshot
                                      in participantesSnapshots.data!) {
                                    // ignore: avoid_print
                                    print(snapshot.data());
                                  }

                                  // ignore: avoid_print
                                  print(viagemData['responsavel']);

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
                                                  veiculoData['imageUrl']
                                                          as String? ??
                                                      'https://s7d1.scene7.com/is/image/hyundai/compare-veiculo-1225x619?wid=600&fmt=webp',
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 200,
                                                ),
                                                const SizedBox(height: 16),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Origem: ${viagemData['cidadeOrigem']} - ${viagemData['estadoOrigem']}',
                                                          ),
                                                          Text(
                                                            'Destino: ${viagemData['cidadeDestino']} - ${viagemData['estadoDestino']}',
                                                          ),
                                                          FutureBuilder<
                                                              DocumentSnapshot>(
                                                            future: viagemData[
                                                                    'responsavel']
                                                                .get(),
                                                            builder: (context,
                                                                responsavelSnapshot) {
                                                              if (responsavelSnapshot
                                                                      .connectionState ==
                                                                  ConnectionState
                                                                      .waiting) {
                                                                return const CircularProgressIndicator(); // or a loading indicator
                                                              }

                                                              if (!responsavelSnapshot
                                                                  .hasData) {
                                                                return const Text(
                                                                    'Responsável: N/A'); // Handle case when 'responsavel' doesn't exist
                                                              }

                                                              final responsavelData =
                                                                  responsavelSnapshot
                                                                          .data
                                                                          ?.data()
                                                                      as Map<
                                                                          String,
                                                                          dynamic>;
                                                              final nome =
                                                                  responsavelData[
                                                                              'nome']
                                                                          as String? ??
                                                                      'N/A';

                                                              return Text(
                                                                'Responsável: $nome',
                                                              );
                                                            },
                                                          ),
                                                          Text(
                                                            'Data prevista de saída: ${viagemData['dataInicio'] != null ? dateFormatter.format(viagemData['dataInicio'].toDate()) : 'Erro ao buscar dado'}',
                                                          ),
                                                          Text(
                                                            'Data prevista de retorno: ${viagemData['dataFim'] != null ? dateFormatter.format(viagemData['dataFim'].toDate()) : 'Erro ao buscar dado'}',
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    if (currentUser !=
                                                        filteredViagens[index]
                                                            .responsavel
                                                            .nome)
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          if (filteredViagens[
                                                                          index]
                                                                      .veiculo
                                                                      .capacidade -
                                                                  filteredViagens[
                                                                          index]
                                                                      .participantes
                                                                      .length <=
                                                              0) {
                                                            return; // Disable the button
                                                          } else {
                                                            onPressedButton(
                                                                index); // Enable the button and handle the click
                                                          }
                                                        },
                                                        style: isParticipatingList[
                                                                index]
                                                            ? ElevatedButton
                                                                .styleFrom(
                                                                backgroundColor:
                                                                    Colors.red,
                                                              )
                                                            : filteredViagens[index]
                                                                            .veiculo
                                                                            .capacidade -
                                                                        filteredViagens[index]
                                                                            .participantes
                                                                            .length <=
                                                                    0
                                                                ? ElevatedButton
                                                                    .styleFrom(
                                                                    backgroundColor:
                                                                        Colors.grey[
                                                                            400], // Use #ccc
                                                                  )
                                                                : null,
                                                        child: Text(
                                                          filteredViagens[index]
                                                                          .veiculo
                                                                          .capacidade -
                                                                      filteredViagens[
                                                                              index]
                                                                          .participantes
                                                                          .length <=
                                                                  0
                                                              ? 'Veículo lotado'
                                                              : isParticipatingList[
                                                                      index]
                                                                  ? 'Desistir'
                                                                  : 'Participar',
                                                        ),
                                                      ),
                                                    if (currentUser ==
                                                        filteredViagens[index]
                                                            .responsavel
                                                            .nome)
                                                      EditTripButton(
                                                        trip: filteredViagens[
                                                            index],
                                                      ),
                                                    if (currentUser ==
                                                        filteredViagens[index]
                                                            .responsavel
                                                            .nome)
                                                      DeleteTripButton(
                                                        index: index,
                                                        onDelete: () =>
                                                            showDeleteConfirmationDialog(
                                                                context, index),
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
                            },
                          );
                        },
                      );
                    } else {
                      return const Text(
                          "Há dados inconsistentes no banco de dados.");
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTripScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
