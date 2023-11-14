import 'package:flutter/material.dart';

class EstadosSelect extends StatefulWidget {
  final List<String> estados;
  final String estadoSelecionadoOrigem;
  final Function(String) onEstadoChanged;
  final String? defaultValue;

  const EstadosSelect({
    super.key,
    required this.estados,
    required this.estadoSelecionadoOrigem,
    required this.onEstadoChanged,
    this.defaultValue,
  });

  @override
  EstadosSelectState createState() => EstadosSelectState();
}

class EstadosSelectState extends State<EstadosSelect> {
  @override
  Widget build(BuildContext context) {
    final uniqueEstados = widget.estados.toSet().toList();

    if (uniqueEstados.isEmpty) {
      // Display a loading indicator or message, or disable the DropdownButtonFormField
      return const Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DropdownButtonFormField<String>(
      value: widget.estadoSelecionadoOrigem.isNotEmpty
          ? widget.estadoSelecionadoOrigem
          : widget.defaultValue,
      onChanged: (value) {
        setState(() {
          widget.onEstadoChanged(value!);
        });
      },
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('Selecione um estado'), // Placeholder text
        ),
        ...uniqueEstados.map((estado) {
          return DropdownMenuItem<String>(
            value: estado,
            child: Text(estado),
          );
        }),
      ],
      decoration: const InputDecoration(
        labelText: 'Estado',
        border: OutlineInputBorder(),
      ),
    );
  }
}
