import 'package:flutter/material.dart';

class CidadesSelect extends StatefulWidget {
  final List<String> cityList;
  final String selectedCity;
  final Function(String) onCityChanged;
  final String? defaultValue;

  const CidadesSelect({
    super.key,
    required this.cityList,
    required this.selectedCity,
    required this.onCityChanged,
    this.defaultValue,
  });

  @override
  CidadesSelectState createState() => CidadesSelectState();
}

class CidadesSelectState extends State<CidadesSelect> {
  @override
  Widget build(BuildContext context) {
    final uniqueCidades = widget.cityList.toSet().toList();

    if (uniqueCidades.isEmpty) {
      if (widget.selectedCity.isNotEmpty) {
        return const SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(),
        );
      }
      return TextFormField(
        decoration: const InputDecoration(
          labelText: 'Cidade',
          border: OutlineInputBorder(),
        ),
        enabled: false,
        initialValue: widget.defaultValue ?? "Selecione uma cidade",
      );
    }

    return DropdownButtonFormField<String>(
      value: widget.selectedCity.isNotEmpty
          ? widget.selectedCity
          : widget.defaultValue,
      onChanged: (value) {
        setState(() {
          widget.onCityChanged(value!);
        });
      },
      items: [
        DropdownMenuItem<String>(
          value: null,
          child: Text(widget.defaultValue ??
              'Selecione uma cidade'), // Placeholder text
        ),
        ...uniqueCidades.map((cidade) {
          return DropdownMenuItem<String>(
            value: cidade,
            child: Text(cidade),
          );
        }),
      ],
      decoration: const InputDecoration(
        labelText: 'Cidade',
        border: OutlineInputBorder(),
      ),
    );
  }
}
