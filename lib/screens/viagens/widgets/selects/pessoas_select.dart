import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/pessoas.dart';

class PessoasSelect extends StatefulWidget {
  final List<Pessoa> pessoas;
  final Pessoa pessoaSelecionada;
  final Function(Pessoa) onPessoaChanged;
  final Pessoa? defaultValue;

  const PessoasSelect({
    super.key,
    required this.pessoas,
    required this.pessoaSelecionada,
    required this.onPessoaChanged,
    this.defaultValue,
  });

  @override
  PessoasSelectState createState() => PessoasSelectState();
}

class PessoasSelectState extends State<PessoasSelect> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Pessoa>(
      value: widget.pessoaSelecionada != widget.defaultValue
          ? widget.defaultValue
          : widget.pessoaSelecionada,
      onChanged: (Pessoa? selectedPessoa) {
        setState(() {
          widget.onPessoaChanged(selectedPessoa!);
        });
      },
      items: [
        ...widget.pessoas.map((pessoa) {
          return DropdownMenuItem<Pessoa>(
            value: pessoa,
            child: Text(pessoa.nome),
          );
        }),
      ],
      decoration: const InputDecoration(
        labelText: 'Responsável',
        border: OutlineInputBorder(),
      ),
    );
  }
}
