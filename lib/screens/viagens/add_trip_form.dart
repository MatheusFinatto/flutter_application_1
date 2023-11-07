import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/veiculos.dart';
import 'package:flutter_application_1/models/veiculos.dart';
import 'package:flutter_application_1/models/viagens.dart';
import 'package:flutter_application_1/screens/viagens/widgets/selects/cidades_select.dart';
import 'package:flutter_application_1/screens/viagens/widgets/selects/estados_select.dart';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AddTripScreen extends StatefulWidget {
  final bool isEdit;
  final Trip? trip;

  const AddTripScreen({Key? key, this.isEdit = false, this.trip})
      : super(key: key);

  @override
  AddTripScreenState createState() => AddTripScreenState();
}

class AddTripScreenState extends State<AddTripScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _estadoSelecionadoOrigem = '';
  String _cidadeSelecionadaOrigem = '';

  String _estadoSelecionadoDestino = '';
  String _cidadeSelecionadaDestino = '';

  DateTime _dataSaida = DateTime.now();
  TimeOfDay _horaSaida = TimeOfDay.now();

  DateTime _dataRetorno = DateTime.now();
  TimeOfDay _horaRetorno = TimeOfDay.now();
  String empresaId = 'UywGfjmMyYNRHFyx5hUN';

  Veiculo? _selectedVeiculo;

  final DateFormat _dateFormatter = DateFormat('dd/MM/yyyy');
  final List<String> estados = [];
  final Map<String, List<String>> cidades = {};

  @override
  void initState() {
    super.initState();
    _fetchEstadosFromAPI();
  }

  Future<void> _fetchEstadosFromAPI() async {
    final response = await http.get(Uri.parse(
        'https://servicodados.ibge.gov.br/api/v1/localidades/estados'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      for (var estado in data) {
        estados.add(estado['sigla']);
      }

      setState(() {});
    }
  }

  Future<void> _fetchCidadesFromAPI(String estado) async {
    final response = await http.get(Uri.parse(
        'https://servicodados.ibge.gov.br/api/v1/localidades/estados/$estado/municipios'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<String> cidadesEstado = [];
      for (var cidade in data) {
        cidadesEstado.add(cidade['nome']);
      }
      cidades[estado] = cidadesEstado;
    }
  }

  Stream<List<Veiculo>> veiculosStream() {
    return FirebaseFirestore.instance
        .collection('empresas')
        .doc(empresaId)
        .collection('veiculos')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        Veiculo veiculo = Veiculo.fromMap(doc.data());
        veiculo.uid = doc.reference.id;
        _selectedVeiculo = veiculo;
        return veiculo;
      }).toList();
    });
  }

  void _salvarDadosNoFirebase() async {
    if (_formKey.currentState!.validate()) {
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        final String currentUserId = currentUser.uid;

        final DateTime startDateTime =
            _combineDateAndTime(_dataSaida, _horaSaida);
        final DateTime endDateTime =
            _combineDateAndTime(_dataRetorno, _horaRetorno);
        final Timestamp startTimestamp = _convertToTimestamp(startDateTime);
        final Timestamp endTimestamp = _convertToTimestamp(endDateTime);
        final DocumentReference responsavelRef =
            FirebaseFirestore.instance.doc('pessoas/$currentUserId');

        final DocumentReference veiculoRef = FirebaseFirestore.instance
            .doc('empresas/$empresaId/veiculos/${_selectedVeiculo?.uid}');

        final List<DocumentReference> participantesRefs =
            _prepareParticipantesRefs(currentUserId);

        final Map<String, dynamic> tripData = {
          'veiculo': veiculoRef,
          'estadoOrigem': _estadoSelecionadoOrigem,
          'cidadeOrigem': _cidadeSelecionadaOrigem,
          'estadoDestino': _estadoSelecionadoDestino,
          'cidadeDestino': _cidadeSelecionadaDestino,
          'dataInicio': startTimestamp,
          'dataFim': endTimestamp,
          'responsavel': responsavelRef,
          'participantes': participantesRefs,
        };

        await _addTripToFirestore(empresaId, tripData);
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  Timestamp _convertToTimestamp(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }

  List<DocumentReference> _prepareParticipantesRefs(String currentUserId) {
    return <DocumentReference>[
      FirebaseFirestore.instance.doc('pessoas/$currentUserId'),
    ];
  }

  Future<void> _addTripToFirestore(
      String empresaId, Map<String, dynamic> tripData) async {
    final CollectionReference viagensCollection =
        FirebaseFirestore.instance.collection('empresas/$empresaId/viagens');
    await viagensCollection.add(tripData);
  }

  Future<void> _setDataSaida(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _dataSaida,
      firstDate: DateTime(2022),
      lastDate: DateTime(2122),
    ) as DateTime;

    if (picked != _dataSaida) {
      setState(() {
        _dataSaida = picked;
      });
    }
  }

  Future<void> _setHoraSaida(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _horaSaida,
    ) as TimeOfDay;
    if (picked != _horaSaida) {
      setState(() {
        _horaSaida = picked;
      });
    }
  }

  Future<void> _setDataRetorno(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _dataRetorno,
      firstDate: DateTime(2022),
      lastDate: DateTime(2122),
    ) as DateTime;

    if (picked != _dataRetorno) {
      setState(() {
        _dataRetorno = picked;
      });
    }
  }

  Future<void> _setHoraRetorno(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _horaRetorno,
    ) as TimeOfDay;
    if (picked != _horaRetorno) {
      setState(() {
        _horaRetorno = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isEdit
            ? const Text('Editar Viagem')
            : const Text('Adicionar Viagem'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Column(
                children: [
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Origem',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        EstadosSelect(
                          estados: estados,
                          estadoSelecionadoOrigem: _estadoSelecionadoOrigem,
                          onEstadoChanged: (value) {
                            setState(() {
                              _estadoSelecionadoOrigem = value;
                              _cidadeSelecionadaOrigem = '';
                              _fetchCidadesFromAPI(value);
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        CidadesSelect(
                          isEstadoSelected: _estadoSelecionadoOrigem != '',
                          cityList: cidades[_estadoSelecionadoOrigem] ?? [],
                          selectedCity: _cidadeSelecionadaOrigem,
                          onCityChanged: (value) {
                            setState(() {
                              _cidadeSelecionadaOrigem = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // "Destino" section
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Destino',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        EstadosSelect(
                          estados: estados,
                          estadoSelecionadoOrigem: _estadoSelecionadoDestino,
                          onEstadoChanged: (value) {
                            setState(() {
                              _estadoSelecionadoDestino = value;
                              _cidadeSelecionadaDestino = '';
                              _fetchCidadesFromAPI(value);
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        CidadesSelect(
                            cityList: cidades[_estadoSelecionadoDestino] ?? [],
                            selectedCity: _cidadeSelecionadaDestino,
                            onCityChanged: (value) {
                              setState(() {
                                _cidadeSelecionadaDestino = value;
                              });
                            })
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Saída',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const SizedBox(height: 16),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'Data: ${_dateFormatter.format(_dataSaida)}',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () {
                                _setDataSaida(context);
                              },
                              child: const Text('Selecionar Data'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'Hora: ${_horaSaida.format(context)}',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () {
                                _setHoraSaida(context);
                              },
                              child: const Text('Selecionar Hora'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // "Destino" section
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Retorno',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'Data: ${_dateFormatter.format(_dataRetorno)}',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () {
                                _setDataRetorno(context);
                              },
                              child: const Text('Selecionar Data'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'Hora: ${_horaRetorno.format(context)}',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () {
                                _setHoraRetorno(context);
                              },
                              child: const Text('Selecionar Hora'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  StreamBuilder<List<Veiculo>>(
                    stream: veiculosStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text("No veiculos found.");
                      }

                      return DropdownButtonFormField<Veiculo>(
                        value: _selectedVeiculo ?? snapshot.data?.first,
                        onChanged: (veiculo) {
                          setState(() {
                            _selectedVeiculo = veiculo;
                          });
                        },
                        items: snapshot.data?.map((veiculo) {
                          return DropdownMenuItem<Veiculo>(
                            value: _selectedVeiculo ?? snapshot.data?.first,
                            key: Key('key-${veiculo.ano}-${veiculo.placa}'),
                            child: Text(
                              '${veiculo.marca} ${veiculo.modelo}, ${veiculo.ano} - ${veiculo.placa}',
                            ),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Veículo',
                          border: OutlineInputBorder(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _salvarDadosNoFirebase();
                      }
                    },
                    child: const Text('Enviar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
