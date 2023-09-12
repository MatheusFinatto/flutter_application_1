import 'package:flutter/material.dart';
import 'AddTripScreen.dart';

// Custom Trip class to hold trip details
class Trip {
  final String carImage; // Placeholder image of the car used
  final String destination;
  final String startDate;
  final String endDate;

  Trip({
    required this.carImage,
    required this.destination,
    required this.startDate,
    required this.endDate,
  });
}

class ViagensScreen extends StatefulWidget {
  const ViagensScreen({Key? key}) : super(key: key);

  @override
  _ViagensScreenState createState() => _ViagensScreenState();
}

class _ViagensScreenState extends State<ViagensScreen> {
  List<Trip> ongoingTrips = [
    // ... (your list of trips remains the same)
  ];

  // Controller for the search input field
  final TextEditingController _searchController = TextEditingController();

  // List to store the filtered trips
  List<Trip> filteredTrips = [];

  @override
  void initState() {
    super.initState();
    // Initialize the filteredTrips list with all the trips initially
    filteredTrips.addAll(ongoingTrips);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Viagens'),
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
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    // Clear the search input field and reset the filteredTrips list
                    _searchController.clear();
                    setState(() {
                      filteredTrips.clear();
                      filteredTrips.addAll(ongoingTrips);
                    });
                  },
                ),
              ),
              onChanged: (query) {
                // Filter the trips based on the search query
                setState(() {
                  filteredTrips = _filterTrips(query);
                });
              },
            ),
          ),
          // Scrollable list of ongoing car trips
          Expanded(
            child: ListView.builder(
              itemCount: filteredTrips.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    // title: Text(filteredTrips[index].title),
                    subtitle: Column(
                      children: [
                        Image.asset(
                          filteredTrips[index].carImage,
                          width: 150,
                          height: 150,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Detino: ${filteredTrips[index].destination}'),
                                  Text(
                                      'Data prevista de saída: ${filteredTrips[index].startDate}'),
                                  Text(
                                      'Data prevista de retorno: ${filteredTrips[index].endDate}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // You can add more details about the trip here if needed
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
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddTripScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  List<Trip> _filterTrips(String query) {
    if (query.isEmpty || query == '') {
      // If the query is empty, return all trips
      return ongoingTrips;
    } else {
      // Filter trips based on the query (you can implement your own logic here)
      return ongoingTrips.where((trip) {
        return trip.destination.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }
}
