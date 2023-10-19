import 'veiculos.dart';
import 'package:flutter_application_1/models/pessoas.dart';

class Trip {
  final String carImage; // Placeholder image of the car used
  final String originState;
  final String originCity;
  final String destinationState;
  final String destinationCity;
  final Pessoa responsavel;
  final DateTime startDate;
  final DateTime endDate;
  final int assentosUtilizados;

  Trip({
    required this.carImage,
    required this.originState,
    required this.originCity,
    required this.destinationState,
    required this.destinationCity,
    required this.startDate,
    required this.responsavel,
    required this.endDate,
    required this.assentosUtilizados,
  });

  static List<Trip> ongoingTrips = [
    Trip(
      carImage:
          veiculosList.firstWhere((veiculo) => veiculo.id == 'uno').imageUrl,
      originState: "RS",
      originCity: 'Erechim',
      destinationState: "RS",
      destinationCity: 'Porto Alegre',
      startDate: DateTime(2023, 9, 16),
      endDate: DateTime(2023, 9, 17),
      assentosUtilizados: 2,
      responsavel: pessoasList[0],
    ),
    Trip(
      carImage:
          veiculosList.firstWhere((veiculo) => veiculo.id == 'palio').imageUrl,
      originState: "RS",
      originCity: 'Erechim',
      destinationState: "RS",
      destinationCity: 'Gaurama',
      startDate: DateTime(2023, 9, 17, 10, 30),
      endDate: DateTime(2023, 9, 18, 14, 30),
      assentosUtilizados: 1,
      responsavel: pessoasList[1],
    ),
    Trip(
        carImage:
            veiculosList.firstWhere((veiculo) => veiculo.id == 'mobi').imageUrl,
        originState: "RS",
        originCity: 'Erechim',
        destinationState: "RS",
        destinationCity: 'Porto Alegre',
        startDate: DateTime(2023, 9, 18, 14, 30),
        endDate: DateTime(2023, 9, 19, 14, 30),
        assentosUtilizados: 4,
        responsavel: pessoasList[2]),
    Trip(
      carImage: veiculosList
          .firstWhere((veiculo) => veiculo.id == 'mustang')
          .imageUrl,
      originState: "RS",
      originCity: 'Erechim',
      destinationState: "RS",
      destinationCity: 'Viadutos',
      startDate: DateTime(2023, 9, 19, 14, 30),
      endDate: DateTime(2023, 9, 20, 14, 30),
      assentosUtilizados: 2,
      responsavel: pessoasList[3],
    ),
    Trip(
      carImage:
          veiculosList.firstWhere((veiculo) => veiculo.id == 'f40').imageUrl,
      originState: "RS",
      originCity: 'Erechim',
      destinationState: "RS",
      destinationCity: 'Porto Alegre',
      startDate: DateTime(2023, 9, 20, 14, 30),
      endDate: DateTime(2023, 9, 21, 14, 30),
      assentosUtilizados: 2,
      responsavel: pessoasList[4],
    ),
  ];

  static void addNewTrip(Trip newTrip) {
    ongoingTrips.add(newTrip);
  }

  static void removeTrip(int index) {
    if (index >= 0 && index < ongoingTrips.length) {
      ongoingTrips.removeAt(index);
    }
  }
}
