import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/pessoas.dart';

class UsersDelete extends StatefulWidget {
  const UsersDelete({super.key});

  @override
  State<UsersDelete> createState() => _UsersDeleteState();
}

class _UsersDeleteState extends State<UsersDelete> {
  String _cpf = "";
  bool _foundUser = false;
  TextEditingController _idController = TextEditingController();
  TextEditingController _cpfController = TextEditingController();
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _enderecoController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  void _deleteUser(String id, String cpf, String nome, String endereco,
      String telefone, String email) {
    // Funcão de delete no Firebase
    // if(o CPF retornou os campos -> deleta)
    // else(pede para o usuário digitar novamente)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deletar Usuário"),
        backgroundColor: const Color.fromARGB(255, 232, 60, 60),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _cpfController,
                decoration: const InputDecoration(
                  labelText: "CPF",
                ),
              ),
              TextFormField(
                controller: _nomeController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: "Nome",
                ),
              ),
              TextFormField(
                controller: _enderecoController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: "Endereço",
                ),
              ),
              TextFormField(
                controller: _telefoneController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: "Telefone",
                ),
              ),
              TextFormField(
                controller: _emailController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: "Email",
                ),
              ),
              const SizedBox(height: 20), // Espaço entre os campos
              ElevatedButton(
                  onPressed: () {
                    _deleteUser(
                        _idController.text,
                        _cpfController.text,
                        _nomeController.text,
                        _enderecoController.text,
                        _telefoneController.text,
                        _emailController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 232, 60, 60),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("Deletar Usuário")],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
