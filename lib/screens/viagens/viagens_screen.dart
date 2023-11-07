import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/pessoas.dart';
import 'package:flutter_application_1/screens/viagens/add_trip_form.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/pessoas.dart';
import 'package:flutter_application_1/database/viagens.dart';
import 'package:flutter_application_1/models/viagens.dart';
import 'package:flutter_application_1/screens/viagens/widgets/buttons/delete_trip_button.dart';
import 'package:flutter_application_1/screens/viagens/widgets/buttons/edit_trip_button.dart';

class ViagensScreen extends StatefulWidget {
  const ViagensScreen({Key? key}) : super(key: key);

  @override
  ViagensScreenState createState() => ViagensScreenState();
}

class ViagensScreenState extends State<ViagensScreen> {
  final TextEditingController _searchController = TextEditingController();
  final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');
  late Pessoa currentUser;
  late List<Trip> filteredViagens;
  late List<bool> isParticipatingList;
  String empresaId = 'UywGfjmMyYNRHFyx5hUN';

  @override
  void initState() {
    super.initState();
    filteredViagens = List.from(viagensList);
    isParticipatingList =
        List.generate(filteredViagens.length, (index) => false);
    getDados();
  }

  void getDados() async {
    Pessoas pessoas = Pessoas();
    Pessoa pessoa = await pessoas.getUserSession();
    setState(() {
      currentUser = pessoa;
    });
  }

  void onPressedButton(int index) {
    setState(() {
      isParticipatingList[index] = !isParticipatingList[index];
    });

    if (filteredViagens[index].veiculo.capacidade -
            filteredViagens[index].participantes.length <=
        0) {
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
              child: const Text('Excluir'),
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
          buildSearchInput(),
          buildTripsList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
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

  Widget buildSearchInput() {
    return Padding(
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
    );
  }

  Widget buildTripsList() {
    return Expanded(
        child: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('empresas')
          .doc(empresaId)
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
            final viagemData =
                snapshot.data?.docs[index].data() as Map<String, dynamic>;

            // Fetch and convert the 'veiculo' document reference

            DocumentReference? veiculoReference =
                viagemData['veiculo'] as DocumentReference?;

            DocumentReference? responsavelReference =
                viagemData['responsavel'] as DocumentReference?;

            if (veiculoReference != null || responsavelReference != null) {
              return FutureBuilder<DocumentSnapshot>(
                future: veiculoReference?.get(),
                builder: (context, veiculoSnapshot) {
                  if (veiculoSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  Map<String, dynamic> veiculoData;
                  if (!veiculoSnapshot.hasData ||
                      !veiculoSnapshot.data!.exists) {
                    veiculoData = {
                      'imageUrl':
                          'https://www.slazzer.com/static/images/design_templates/car_design_template/car_placeholder.png',
                      // Add other placeholder data here
                    };
                  } else {
                    veiculoData =
                        veiculoSnapshot.data!.data() as Map<String, dynamic>;
                  }

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

                      final DateTime dataInicio = viagemData['dataInicio'] !=
                              null
                          ? viagemData['dataInicio'].toDate()
                          : DateTime
                              .now(); // Replace with the appropriate default date

                      final DateTime dataFim = viagemData['dataFim'] != null
                          ? viagemData['dataFim'].toDate()
                          : DateTime
                              .now(); // Replace with the appropriate default date

                      final DateFormat dateTimeFormatter =
                          DateFormat('dd/MM/yyyy HH:mm');

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
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Origem: ${viagemData['cidadeOrigem']} - ${viagemData['estadoOrigem']}',
                                              ),
                                              Text(
                                                'Destino: ${viagemData['cidadeDestino']} - ${viagemData['estadoDestino']}',
                                              ),
                                              FutureBuilder<DocumentSnapshot>(
                                                future:
                                                    viagemData['responsavel']
                                                        .get(),
                                                builder: (context,
                                                    responsavelSnapshot) {
                                                  if (responsavelSnapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const CircularProgressIndicator(); // or a loading indicator
                                                  }

                                                  if (!responsavelSnapshot
                                                      .hasData) {
                                                    return const Text(
                                                        'Responsável: N/A'); // Handle case when 'responsavel' doesn't exist
                                                  }

                                                  final responsavelData =
                                                      responsavelSnapshot.data
                                                              ?.data()
                                                          as Map<String,
                                                              dynamic>;
                                                  final nome =
                                                      responsavelData['nome']
                                                              as String? ??
                                                          'N/A';

                                                  return Text(
                                                    'Responsável: $nome',
                                                  );
                                                },
                                              ),
                                              Text(
                                                'Data prevista de saída: ${dateTimeFormatter.format(dataInicio)}',
                                              ),
                                              Text(
                                                'Data prevista de retorno: ${dateTimeFormatter.format(dataFim)}',
                                              ),
                                              Text(
                                                'Participantes: ${viagemData['participantes'].length}',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    FutureBuilder<DocumentSnapshot>(
                                      future: viagemData['responsavel'].get(),
                                      builder: (context, responsavelSnapshot) {
                                        if (responsavelSnapshot
                                                .connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator(); // or a loading indicator
                                        }

                                        if (!responsavelSnapshot.hasData) {
                                          return const Text(
                                              'Responsável: N/A'); // Handle case when 'responsavel' doesn't exist
                                        }

                                        final responsavelData =
                                            responsavelSnapshot.data?.data()
                                                as Map<String, dynamic>;
                                        final email = responsavelData['email']
                                                as String? ??
                                            'N/A';

                                        return Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (currentUser.email != email)
                                                ElevatedButton(
                                                  onPressed: () {
                                                    if (filteredViagens[index]
                                                                .veiculo
                                                                .capacidade -
                                                            viagemData[
                                                                    'participantes']
                                                                .length <=
                                                        0) {
                                                      return; // Disable the button
                                                    } else {
                                                      onPressedButton(index);
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
                                                                  viagemData[
                                                                          'participantes']
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
                                                                viagemData[
                                                                        'participantes']
                                                                    .length <=
                                                            0
                                                        ? 'Veículo lotado'
                                                        : isParticipatingList[
                                                                index]
                                                            ? 'Desistir'
                                                            : 'Participar',
                                                  ),
                                                ),
                                              if (currentUser.email == email)
                                                EditTripButton(
                                                  trip: filteredViagens[index],
                                                ),
                                              if (currentUser.email == email)
                                                DeleteTripButton(
                                                  index: index,
                                                  onDelete: () =>
                                                      showDeleteConfirmationDialog(
                                                          context, index),
                                                )
                                            ]);
                                      },
                                    ),
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
            } else {
              return const Text("Há dados inconsistentes no banco de dados.");
            }
          },
        );
      },
    ));
  }
}
