import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

// Estado and Cidade variables for Origem
  String _estadoSelecionadoOrigem = '';
  String _cidadeSelecionadaOrigem = '';
  final List<String> estadosOrigem = [];
  final Map<String, List<String>> cidadesOrigem = {};

  // Estado and Cidade variables for Destino
  String _estadoSelecionadoDestino = '';
  String _cidadeSelecionadaDestino = '';
  final List<String> estadosDestino = [];
  final Map<String, List<String>> cidadesDestino = {};

  DateTime _dataSaida = DateTime.now();
  TimeOfDay _horaSaida = TimeOfDay.now();

  DateTime _dataRetorno = DateTime.now();
  TimeOfDay _horaRetorno = TimeOfDay.now();
  String empresaId = 'UywGfjmMyYNRHFyx5hUN';

  Veiculo _selectedVeiculo = Veiculo(
      marca: '', modelo: '', placa: '', ano: '', capacidade: 0, imageUrl: '');

  final DateFormat _dateFormatter = DateFormat('dd/MM/yyyy');

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
        estadosOrigem.add(estado['sigla']);
        estadosDestino.add(estado['sigla']);
      }

      setState(() {});
    }
  }

  Future<void> _fetchCidadesFromAPI(String estado, bool isOrigem) async {
    final response = await http.get(Uri.parse(
        'https://servicodados.ibge.gov.br/api/v1/localidades/estados/$estado/municipios'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<String> cidadesEstado = [];
      for (var cidade in data) {
        cidadesEstado.add(cidade['nome']);
      }

      if (isOrigem) {
        setState(() {
          cidadesOrigem[estado] = cidadesEstado;
        });
      } else {
        setState(() {
          cidadesDestino[estado] = cidadesEstado;
        });
      }
    }
  }

  void _salvarDadosNoFirebase() async {
    if (_formKey.currentState!.validate()) {
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        final String currentUserId = currentUser.uid;

        final DateTime dataInicioTime =
            _combineDateAndTime(_dataSaida, _horaSaida);
        final DateTime dataFimTime =
            _combineDateAndTime(_dataRetorno, _horaRetorno);
        final Timestamp startTimestamp = _convertToTimestamp(dataInicioTime);
        final Timestamp endTimestamp = _convertToTimestamp(dataFimTime);
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
        Navigator.pop(context);
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
                          estados: estadosOrigem,
                          estadoSelecionadoOrigem: _estadoSelecionadoOrigem,
                          onEstadoChanged: (value) {
                            setState(() {
                              _estadoSelecionadoOrigem = value;
                              _cidadeSelecionadaOrigem = '';
                              _fetchCidadesFromAPI(value, true);
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        CidadesSelect(
                          cityList:
                              cidadesOrigem[_estadoSelecionadoOrigem] ?? [],
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
                  // Destino section
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
                          estados: estadosDestino,
                          estadoSelecionadoOrigem: _estadoSelecionadoDestino,
                          onEstadoChanged: (value) {
                            setState(() {
                              _estadoSelecionadoDestino = value;
                              _cidadeSelecionadaDestino = '';
                              _fetchCidadesFromAPI(value, false);
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        CidadesSelect(
                          cityList:
                              cidadesDestino[_estadoSelecionadoDestino] ?? [],
                          selectedCity: _cidadeSelecionadaDestino,
                          onCityChanged: (value) {
                            setState(() {
                              _cidadeSelecionadaDestino = value;
                            });
                          },
                        ),
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
                    stream: FirebaseFirestore.instance
                        .collection('empresas')
                        .doc(empresaId)
                        .collection('veiculos')
                        .snapshots()
                        .map((querySnapshot) {
                      final veiculos = querySnapshot.docs.map((doc) {
                        return Veiculo.fromMap(doc.data())
                          ..uid = doc.reference.id;
                      }).toList();
                      return veiculos;
                    }),
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

                      return DropdownButtonFormField<String>(
                        value: _selectedVeiculo.uid,
                        onChanged: (value) {
                          setState(() {
                            _selectedVeiculo = snapshot.data!.firstWhere(
                              (veiculo) => veiculo.uid == value,
                            );
                          });
                        },
                        items: snapshot.data?.map((veiculo) {
                          print('selected veiculo ${_selectedVeiculo}');
                          print('veiculo $veiculo');
                          return DropdownMenuItem<String>(
                            value: veiculo.uid,
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
