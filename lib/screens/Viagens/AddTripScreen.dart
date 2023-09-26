import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AddTripScreen extends StatefulWidget {
  const AddTripScreen({Key? key}) : super(key: key);

  @override
  _AddTripScreenState createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _estadoSelecionadoOrigem = '';
  String _cidadeSelecionadaOrigem = '';

  String _estadoSelecionadoDestino = '';
  String _cidadeSelecionadaDestino = '';

  DateTime _dataSaida = DateTime.now();
  TimeOfDay _horaSaida = TimeOfDay.now();

  DateTime _dataRetorno = DateTime.now();
  TimeOfDay _horaRetorno = TimeOfDay.now();

  int _assentosUtilizados = 1;

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
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Nova Viagem'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Column(
                children: [
                  // "Origem" section
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Origem',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const SizedBox(height: 16),
                        StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            final uniqueEstados = estados.toSet().toList();

                            if (uniqueEstados.isEmpty) {
                              // Display a loading indicator or message, or disable the DropdownButtonFormField
                              return Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  child:
                                      CircularProgressIndicator(), // or another loading widget
                                ),
                              );
                            }

                            return DropdownButtonFormField<String>(
                              value: _estadoSelecionadoOrigem.isNotEmpty
                                  ? _estadoSelecionadoOrigem
                                  : uniqueEstados.first,
                              onChanged: (value) {
                                setState(() {
                                  _estadoSelecionadoOrigem = value!;
                                  _cidadeSelecionadaOrigem = '';
                                  _fetchCidadesFromAPI(value);
                                });
                              },
                              items: uniqueEstados.map((estado) {
                                return DropdownMenuItem<String>(
                                  value: estado,
                                  child: Text(estado),
                                );
                              }).toList(),
                              decoration: const InputDecoration(
                                labelText: 'Estado',
                                border: OutlineInputBorder(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            final cidadesEstado =
                                cidades[_estadoSelecionadoOrigem] ?? [];
                            final uniqueCidades =
                                cidadesEstado.toSet().toList();

                            if (uniqueCidades.isEmpty) {
                              if (_estadoSelecionadoOrigem.isNotEmpty) {
                                return Container(
                                  width: 40,
                                  height: 40,
                                  child:
                                      CircularProgressIndicator(), // or another loading widget
                                );
                              }
                              return TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Cidade',
                                  border: OutlineInputBorder(),
                                ),
                                enabled: false,
                                initialValue: "Por favor, selecione um estado",
                              );
                              // Display a loading indicator or message, or disable the DropdownButtonFormField
                            }

                            return DropdownButtonFormField<String>(
                              value: _cidadeSelecionadaOrigem.isNotEmpty
                                  ? _cidadeSelecionadaOrigem
                                  : uniqueCidades.first,
                              onChanged: (value) {
                                setState(() {
                                  _cidadeSelecionadaOrigem = value!;
                                });
                              },
                              items: uniqueCidades.map((cidade) {
                                return DropdownMenuItem<String>(
                                  value: cidade,
                                  child: Text(cidade),
                                );
                              }).toList(),
                              decoration: const InputDecoration(
                                labelText: 'Cidade',
                                border: OutlineInputBorder(),
                              ),
                            );
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
                        Text(
                          'Destino',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const SizedBox(height: 16),
                        StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            final uniqueEstados = estados.toSet().toList();

                            if (uniqueEstados.isEmpty) {
                              // Display a loading indicator or message, or disable the DropdownButtonFormField
                              return Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  child:
                                      CircularProgressIndicator(), // or another loading widget
                                ),
                              );
                            }

                            return DropdownButtonFormField<String>(
                              value: _estadoSelecionadoDestino.isNotEmpty
                                  ? _estadoSelecionadoDestino
                                  : uniqueEstados.first,
                              onChanged: (value) {
                                setState(() {
                                  _estadoSelecionadoDestino = value!;
                                  _cidadeSelecionadaDestino = '';
                                  _fetchCidadesFromAPI(value);
                                });
                              },
                              items: uniqueEstados.map((estado) {
                                return DropdownMenuItem<String>(
                                  value: estado,
                                  child: Text(estado),
                                );
                              }).toList(),
                              decoration: const InputDecoration(
                                labelText: 'Estado',
                                border: OutlineInputBorder(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            final cidadesEstado =
                                cidades[_estadoSelecionadoDestino] ?? [];
                            final uniqueCidades =
                                cidadesEstado.toSet().toList();

                            if (uniqueCidades.isEmpty) {
                              if (_estadoSelecionadoDestino.isNotEmpty) {
                                return Container(
                                  width: 40, // Set the desired width here
                                  child:
                                      CircularProgressIndicator(), // or another loading widget
                                );
                              }
                              return TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Cidade',
                                  border: OutlineInputBorder(),
                                ),
                                enabled: false,
                                initialValue: "Por favor, selecione um estado",
                              );
                              // Display a loading indicator or message, or disable the DropdownButtonFormField
                            }

                            return DropdownButtonFormField<String>(
                              value: _cidadeSelecionadaDestino.isNotEmpty
                                  ? _cidadeSelecionadaDestino
                                  : uniqueCidades.first,
                              onChanged: (value) {
                                setState(() {
                                  _cidadeSelecionadaDestino = value!;
                                });
                              },
                              items: uniqueCidades.map((cidade) {
                                return DropdownMenuItem<String>(
                                  value: cidade,
                                  child: Text(cidade),
                                );
                              }).toList(),
                              decoration: const InputDecoration(
                                labelText: 'Cidade',
                                border: OutlineInputBorder(),
                              ),
                            );
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
                        Text(
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
                            SizedBox(width: 16),
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
                            SizedBox(width: 16),
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
                        Text(
                          'Retorno',
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
                                'Data: ${_dateFormatter.format(_dataRetorno)}',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            SizedBox(width: 16),
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
                            SizedBox(width: 16),
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
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Assentos ocupados',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o número de assentos que serão ocupados';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _assentosUtilizados = int.parse(value!);
                    },
                  ),
                  const SizedBox(height: 16),

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

  void _salvarDadosNoFirebase() {
    // Implement your Firebase database saving logic here
  }

  Future<void> _setDataSaida(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _dataSaida,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
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
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
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
}
