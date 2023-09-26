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
  // List of mocked ongoing car trips using the Trip class
  List<Trip> ongoingTrips = [
    Trip(
      // title: 'Viagem 1: De Erechim para Porto Alegre',
      carImage: 'assets/images/redcar.jpg',
      destination: 'Porto Alegre',
      startDate: '15/09/2023',
      endDate: '19/09/2023',
    ),
    Trip(
      // title: 'Viagem 2: De Erechim para Gaurama',
      carImage: 'assets/images/silvercar.jpg',
      destination: 'Gaurama',
      startDate: '16/09/2023',
      endDate: '17/09/2023',
    ),
    Trip(
      // title: 'Viagem 3: De Erechim para Porto Alegre',
      carImage: 'assets/images/blackcar.jpg',
      destination: 'Porto Alegre',
      startDate: '17/09/2023',
      endDate: '17/09/2023',
    ),
    Trip(
      // title: 'Viagem 4: De Erechim para Viadutos',
      carImage: 'assets/images/redcar.jpg',
      destination: 'Viadutos',
      startDate: '18/09/2023',
      endDate: '19/09/2023',
    ),
    Trip(
      // title: 'Viagem 5: De Erechim para Porto Alegre',
      carImage: 'assets/images/blackcar.jpg',
      destination: 'Porto Alegre',
      startDate: '19/09/2023',
      endDate: '28/09/2023',
    ),
    // Add more trips here...
  ];

  // Controller for the search input field
  final TextEditingController _searchController = TextEditingController();

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
                    // Clear the search input field
                    _searchController.clear();
                  },
                ),
              ),
              onChanged: (query) {
                // Filter the trips based on the search query
                setState(() {
                  ongoingTrips = _filterTrips(query);
                });
              },
            ),
          ),
          // Scrollable list of ongoing car trips
          Expanded(
            child: ListView.builder(
              itemCount: ongoingTrips.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    // title: Text(ongoingTrips[index].title),
                    subtitle: Column(
                      children: [
                        Image.asset(
                          ongoingTrips[index].carImage,
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
                                      'Detino: ${ongoingTrips[index].destination}'),
                                  Text(
                                      'Data prevista de saída: ${ongoingTrips[index].startDate}'),
                                  Text(
                                      'Data prevista de retorno: ${ongoingTrips[index].endDate}'),
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

  // Function to filter the trips based on the search query
  List<Trip> _filterTrips(String query) {
    print(query);
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
