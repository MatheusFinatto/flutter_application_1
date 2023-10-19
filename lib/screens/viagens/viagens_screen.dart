import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/viagens.dart';
import 'package:intl/intl.dart';
import 'add_trip_form.dart';

class ViagensScreen extends StatefulWidget {
  const ViagensScreen({Key? key}) : super(key: key);

  @override
  ViagensScreenState createState() => ViagensScreenState();
}

class ViagensScreenState extends State<ViagensScreen> {
  // List of mocked ongoing car trips using the Trip class
  List<Trip> ongoingTrips = Trip.ongoingTrips;

  // Controller for the search input field
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');

    void showDeleteConfirmationDialog(BuildContext context, int index) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Trip'),
            content: const Text('Are you sure you want to delete this trip?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // Remove the trip and close the dialog
                  Trip.removeTrip(index);
                  Navigator.of(context).pop();
                  updateTripsList();
                },
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );
    }

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
                labelText: 'Search for trips',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      ongoingTrips = Trip.ongoingTrips;
                    });
                  },
                ),
              ),
              onChanged: (query) {
                // Filter the trips based on the search query
                setState(() {
                  _filterTrips(query);
                });
              },
            ),
          ),
          // Scrollable list of ongoing car trips
          Expanded(
            child: ListView.builder(
              itemCount: ongoingTrips.length,
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
                      contentPadding: const EdgeInsets.all(8.0),
                      subtitle: Column(
                        children: [
                          Image.asset(
                            ongoingTrips[index].carImage,
                            width: 200,
                            height: 200,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Origem: ${ongoingTrips[index].originCity} - ${ongoingTrips[index].originState}'),
                                    Text(
                                        'Destino: ${ongoingTrips[index].destinationCity} - ${ongoingTrips[index].destinationState}'),
                                    Text(
                                        'Responsável: ${ongoingTrips[index].responsavel}'),
                                    Text(
                                        'Data prevista de saída: ${dateFormatter.format(ongoingTrips[index].startDate)}'),
                                    Text(
                                        'Data prevista de retorno: ${dateFormatter.format(ongoingTrips[index].endDate)}'),
                                    Text(
                                        'Assentos utilizados: ${ongoingTrips[index].assentosUtilizados}'),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddTripScreen(
                                                      isEdit: true,
                                                      trip:
                                                          ongoingTrips[index]),
                                            ),
                                          )
                                          .then((value) => updateTripsList());
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      showDeleteConfirmationDialog(
                                          context, index);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
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
      // Floating action button to add a new trip
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the page for adding a new trip
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => const AddTripScreen(),
                ),
              )
              .then((value) => updateTripsList());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void updateTripsList() {
    setState(() {
      ongoingTrips = Trip.ongoingTrips;
    });
  }

  // Function to filter the trips based on the search query
  void _filterTrips(String query) {
    if (query.isEmpty || query == '') {
      // If the query is empty, return all trips
      setState(() {
        ongoingTrips = Trip.ongoingTrips;
      });
    } else {
      setState(() {
        ongoingTrips = Trip.ongoingTrips.where((trip) {
          return trip.destinationCity
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
      });
    }
  }
}
