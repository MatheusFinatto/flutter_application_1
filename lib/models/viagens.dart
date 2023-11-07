import 'package:flutter_application_1/models/pessoas.dart';
import 'package:flutter_application_1/models/veiculos.dart';

class Trip {
  final Veiculo veiculo;
  final String estadoOrigem;
  final String cidadeOrigem;
  final String estadoDestino;
  final String cidadeDestino;
  final Pessoa responsavel;
  final DateTime startDate;
  final DateTime dataFim;
  final List<Pessoa> participantes;

  Trip({
    required this.veiculo,
    required this.estadoOrigem,
    required this.cidadeOrigem,
    required this.estadoDestino,
    required this.cidadeDestino,
    required this.startDate,
    required this.responsavel,
    required this.dataFim,
    required this.participantes,
  });

  // Factory constructor to create a Trip object from a Firebase document (Map)

  factory Trip.fromMap(Map<String, dynamic> map) {
    try {
      // Parse the data from the map and create a Trip object
      return Trip(
        veiculo: Veiculo.fromMap(map['veiculo']),
        estadoOrigem: map['estadoOrigem'],
        cidadeOrigem: map['cidadeOrigem'],
        estadoDestino: map['estadoDestino'],
        cidadeDestino: map['cidadeDestino'],
        startDate: DateTime.parse(map['startDate']),
        responsavel: Pessoa.fromMap(map['responsavel']),
        endDate: DateTime.parse(map['endDate']),
        participantes: (map['participantes'] as List)
            .map((participant) => Pessoa.fromMap(participant))
            .toList(),
      );
    } catch (e) {
      // Handle any errors or exceptions, and log the data for debugging
      // ignore: avoid_print
      print('Error creating Trip from map: $e');
      // ignore: avoid_print
      print('Data: $map');
      throw Exception('Error creating Trip from map: $e');
    }
  }

  static void addNewTrip(Trip newTrip) {
    viagensList.add(newTrip);
  }

  factory Trip.fromMap(Map<String, dynamic> map) {
    try {
      // Parse the data from the map and create a Trip object
      return Trip(
        veiculo: Veiculo.fromMap(map['veiculo']),
        estadoOrigem: map['estadoOrigem'],
        cidadeOrigem: map['cidadeOrigem'],
        estadoDestino: map['estadoDestino'],
        cidadeDestino: map['cidadeDestino'],
        startDate: DateTime.parse(map['startDate']),
        responsavel: Pessoa.fromMap(map['responsavel']),
        dataFim: DateTime.parse(map['dataFim']),
        participantes: (map['participantes'] as List)
            .map((participant) => Pessoa.fromMap(participant))
            .toList(),
      );
    } catch (e) {
      // Handle any errors or exceptions, and log the data for debugging
      print('Error creating Trip from map: $e');
      print('Data: $map');
      throw Exception('Error creating Trip from map: $e');
    }
  }

  // Define the toJson method to convert the Trip object to a JSON format.
  Map<String, dynamic> toJson() {
    return {
      'veiculo': veiculo
          .toJson(), // You should define a toJson method for Veiculo as well.
      'estadoOrigem': estadoOrigem,
      'cidadeOrigem': cidadeOrigem,
      'estadoDestino': estadoDestino,
      'cidadeDestino': cidadeDestino,
      'startDate': startDate.toIso8601String(),
      'dataFim': dataFim.toIso8601String(),
      'responsavel': responsavel
          .toJson(), // You should define a toJson method for Pessoa as well.
      'participantes': participantes,
    };
  }
}
