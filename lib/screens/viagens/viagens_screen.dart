import 'add_trip_form.dart';
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

    if (filteredViagens[index].vehicle.capacidade -
            filteredViagens[index].participantes.length <=
        0) {
      // Vehicle is full; you can display a message or do nothing
      return;
    }

    if (filteredViagens[index].vehicle.capacidade -
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
        return trip.destinationCity.toLowerCase().contains(query.toLowerCase());
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
                    filterTrips('');
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
          // Scrollable list of ongoing car trips
          Expanded(
            child: ListView.builder(
              itemCount: filteredViagens.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0.001,
                        blurRadius: 5,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                      subtitle: Column(
                        children: [
                          Image.asset(
                            filteredViagens[index].vehicle.imageUrl,
                            width: 300,
                            height: 200,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Origem: ${filteredViagens[index].originCity} - ${filteredViagens[index].originState}',
                                        style: const TextStyle(fontSize: 16)),
                                    Text(
                                      'Destino: ${filteredViagens[index].destinationCity} - ${filteredViagens[index].destinationState}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'Responsável: ${filteredViagens[index].responsavel.nome}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'Data prevista de saída: ${dateFormatter.format(filteredViagens[index].startDate)}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'Data prevista de retorno: ${dateFormatter.format(filteredViagens[index].endDate)}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'Assentos disponíveis: ${filteredViagens[index].vehicle.capacidade - filteredViagens[index].participantes.length}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (currentUser !=
                                  filteredViagens[index].responsavel.nome)
                                ElevatedButton(
                                  onPressed: () {
                                    if (filteredViagens[index]
                                                .vehicle
                                                .capacidade -
                                            filteredViagens[index]
                                                .participantes
                                                .length <=
                                        0) {
                                      return null; // Disable the button
                                    } else {
                                      onPressedButton(
                                          index); // Enable the button and handle the click
                                    }
                                  },
                                  style: isParticipatingList[index]
                                      ? ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        )
                                      : filteredViagens[index]
                                                      .vehicle
                                                      .capacidade -
                                                  filteredViagens[index]
                                                      .participantes
                                                      .length <=
                                              0
                                          ? ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.grey[400], // Use #ccc
                                            )
                                          : null,
                                  child: Text(
                                    filteredViagens[index].vehicle.capacidade -
                                                filteredViagens[index]
                                                    .participantes
                                                    .length <=
                                            0
                                        ? 'Veículo lotado'
                                        : isParticipatingList[index]
                                            ? 'Desistir'
                                            : 'Participar',
                                  ),
                                ),
                              if (currentUser ==
                                  filteredViagens[index].responsavel.nome)
                                EditTripButton(
                                  trip: filteredViagens[index],
                                ),
                              if (currentUser ==
                                  filteredViagens[index].responsavel.nome)
                                DeleteTripButton(
                                  index: index,
                                  onDelete: () => showDeleteConfirmationDialog(
                                      context, index),
                                ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
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
