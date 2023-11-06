import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/pessoas.dart';
import 'package:flutter_application_1/database/veiculos.dart';
import 'package:flutter_application_1/database/viagens.dart';
import 'package:flutter_application_1/models/pessoas.dart';
import 'package:flutter_application_1/models/veiculos.dart';
import 'package:flutter_application_1/models/viagens.dart';
import 'package:flutter_application_1/screens/viagens/widgets/selects/cidades_select.dart';
import 'package:flutter_application_1/screens/viagens/widgets/selects/estados_select.dart';
import 'package:flutter_application_1/screens/viagens/widgets/selects/pessoas_select.dart';

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

  Veiculo _selectedVeiculo = veiculosList[0];
  Pessoa _selectedPessoa = pessoasList[0];

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

                  PessoasSelect(
                    defaultValue: widget.trip?.responsavel,
                    pessoas: pessoasList,
                    pessoaSelecionada: _selectedPessoa,
                    onPessoaChanged: (newPessoa) {
                      setState(() {
                        _selectedPessoa = newPessoa;
                      });
                    },
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
                          'Origem',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        EstadosSelect(
                          defaultValue: widget.trip?.originState,
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
                          defaultValue: widget.trip?.originCity,
                          cityList: cidades[_estadoSelecionadoOrigem] ??
                              [], // List of cities for the selected state
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
                          defaultValue: widget.trip?.destinationState,
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
                            defaultValue: widget.trip?.destinationCity,
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
                  DropdownButtonFormField<Veiculo>(
                    value: _selectedVeiculo,
                    onChanged: (veiculo) {
                      setState(() {
                        _selectedVeiculo = veiculo ?? veiculosList.first;
                      });
                    },
                    items: veiculosList.map((veiculo) {
                      return DropdownMenuItem<Veiculo>(
                        value:
                            veiculo, // Set the value to the complete Veiculo object
                        child: Text(
                          '${veiculo.marca} ${veiculo.modelo}, ${veiculo.ano} - ${veiculo.placa}',
                        ),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Veículo',
                      border: OutlineInputBorder(),
                    ),
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
    if (_formKey.currentState!.validate()) {
      Veiculo selectedVeiculo = _selectedVeiculo;
      Trip newTrip = Trip(
        vehicle: selectedVeiculo,
        originState: _estadoSelecionadoOrigem,
        originCity: _cidadeSelecionadaOrigem,
        destinationState: _estadoSelecionadoDestino,
        destinationCity: _cidadeSelecionadaDestino,
        startDate: _dataSaida,
        endDate: _dataRetorno,
        responsavel: _selectedPessoa,
        participantes: [],
      );
      viagensList.add(newTrip);
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _setDataSaida(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: widget.trip?.startDate ?? _dataSaida,
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
}
