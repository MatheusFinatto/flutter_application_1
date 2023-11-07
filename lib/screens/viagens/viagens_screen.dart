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
  late Pessoa currentUser = pessoasList[0];

  String empresaId = 'UywGfjmMyYNRHFyx5hUN';

  @override
  void initState() {
    super.initState();
    getDados();
  }

  void getDados() async {
    Pessoas pessoas = Pessoas();
    Pessoa pessoa = await pessoas.getUserSession() as Pessoa;
    setState(() {
      currentUser = pessoa;
    });
  }

  void onPressedButton(participantesReference, viagemId) {
    FirebaseFirestore.instance
        .collection('empresas')
        .doc(empresaId)
        .collection('viagens')
        .doc(viagemId) // Specify the document ID for the viagem
        .get()
        .then((viagemSnapshot) {
      if (viagemSnapshot.exists) {
        // Retrieve the current document data
        var viagemData = viagemSnapshot.data() as Map<String, dynamic>;

        bool containsGivenId = participantesReference.any((reference) {
          final String referenceId = reference.id;
          return referenceId == currentUser.id;
        });

        // Modify the participantes array
        List<DocumentReference> participantes =
            (viagemData['participantes'] as List<dynamic> ?? [])
                .map((participant) {
                  if (participant is DocumentReference) {
                    return participant;
                  } else if (participant is String) {
                    // Assuming the format is 'pessoas/userId'
                    return FirebaseFirestore.instance.doc(participant);
                  }
                  return null;
                })
                .whereType<DocumentReference>()
                .toList();

        if (containsGivenId) {
          participantes.remove(
              FirebaseFirestore.instance.doc('pessoas/${currentUser.id}'));
        } else {
          participantes
              .add(FirebaseFirestore.instance.doc('pessoas/${currentUser.id}'));
        }

        // Update the document with the modified data
        viagemSnapshot.reference.update({'participantes': participantes});

        SnackBar snackBar = SnackBar(
          content: Text(!containsGivenId
              ? "Pedido para participação enviado com sucesso!"
              : "Pedido de participação cancelado!"),
          duration: const Duration(seconds: 2),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        print('Document with ID $viagemId does not exist.');
      }
    });
  }

  // void filterTrips(String query) {
  //   setState(() {
  //     filteredViagens = viagensList.where((trip) {
  //       return trip.cidadeDestino.toLowerCase().contains(query.toLowerCase());
  //     }).toList();
  //   });
  // }

  void showDeleteConfirmationDialog(BuildContext context, viagemId) {
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
                // Excluir viagem from firebase
                FirebaseFirestore.instance
                    .collection('empresas')
                    .doc(empresaId)
                    .collection('viagens')
                    .doc(viagemId)
                    .delete();
                Navigator.of(context).pop();
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
    return const Padding(
      padding: EdgeInsets.all(16.0),
      //     child: TextField(
      //       controller: _searchController,
      //       decoration: InputDecoration(
      //         labelText: 'Buscar por destino',
      //         suffixIcon: IconButton(
      //           icon: const Icon(Icons.clear),
      //           onPressed: () {
      //             _searchController.clear();
      //           },
      //         ),
      //       ),
      //       onChanged: (query) {
      //         setState(() {
      //           filterTrips(query);
      //         });
      //       },
      //     ),
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
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text("No viagens found.");
        }

        return ListView.builder(
          itemCount: snapshot.data?.docs.length,
          itemBuilder: (context, index) {
            final viagemData =
                snapshot.data?.docs[index].data() as Map<String, dynamic>;

            final viagemId = snapshot.data?.docs[index].id;

            DocumentReference? veiculoReference =
                viagemData['veiculo'] as DocumentReference?;

            DocumentReference? responsavelReference =
                viagemData['responsavel'] as DocumentReference?;

            List<DocumentReference<Object?>>? participantesReference = [];

            if (viagemData['participantes'] != null) {
              final List<dynamic> dynamicList = viagemData['participantes'];
              participantesReference =
                  dynamicList.whereType<DocumentReference<Object?>>().toList();
            }

            bool containsGivenId = participantesReference.any((reference) {
              final String referenceId = reference.id;

              return referenceId == currentUser.id;
            });

            if (veiculoReference != null || responsavelReference != null) {
              return FutureBuilder<DocumentSnapshot>(
                future: veiculoReference?.get(),
                builder: (context, veiculoSnapshot) {
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
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!responsavelSnapshot.hasData ||
                          !responsavelSnapshot.data!.exists) {
                        return const Text("No responsavel found.");
                      }

                      final DateTime dataInicio =
                          viagemData['dataInicio'] != null
                              ? viagemData['dataInicio'].toDate()
                              : DateTime.now();

                      final DateTime dataFim = viagemData['dataFim'] != null
                          ? viagemData['dataFim'].toDate()
                          : DateTime.now();

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
                                                    if (veiculoData[
                                                                'capacidade'] -
                                                            viagemData[
                                                                    'participantes']
                                                                .length <=
                                                        0) {
                                                      return; // Disable the button
                                                    } else {
                                                      onPressedButton(
                                                          participantesReference,
                                                          viagemId);
                                                    }
                                                  },
                                                  style: containsGivenId
                                                      ? ElevatedButton
                                                          .styleFrom(
                                                          backgroundColor:
                                                              Colors.red,
                                                        )
                                                      : veiculoData['capacidade'] -
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
                                                    veiculoData['capacidade'] -
                                                                viagemData[
                                                                        'participantes']
                                                                    .length <=
                                                            0
                                                        ? 'Veículo lotado'
                                                        : containsGivenId
                                                            ? 'Desistir'
                                                            : 'Participar',
                                                  ),
                                                ),
                                              if (currentUser.email == email)
                                                EditTripButton(
                                                  //TODO: remove placeholder
                                                  trip: viagemData,
                                                ),
                                              if (currentUser.email == email)
                                                DeleteTripButton(
                                                  index: index,
                                                  onDelete: () =>
                                                      showDeleteConfirmationDialog(
                                                          context, viagemId),
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
