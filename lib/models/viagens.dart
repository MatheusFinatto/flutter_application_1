import 'package:flutter_application_1/database/viagens.dart';
import 'package:flutter_application_1/models/pessoas.dart';
import 'package:flutter_application_1/models/veiculos.dart';

class Trip {
  final Veiculo vehicle;
  final String originState;
  final String originCity;
  final String destinationState;
  final String destinationCity;
  final Pessoa responsavel;
  final DateTime startDate;
  final DateTime endDate;
  final List<Pessoa> participantes;

  Trip({
    required this.vehicle,
    required this.originState,
    required this.originCity,
    required this.destinationState,
    required this.destinationCity,
    required this.startDate,
    required this.responsavel,
    required this.endDate,
    required this.participantes,
  });

  static void addNewTrip(Trip newTrip) {
    viagensList.add(newTrip);
  }

  static void removeTrip(int index) {
    if (index >= 0 && index < viagensList.length) {
      viagensList.removeAt(index);
    }
  }
}
