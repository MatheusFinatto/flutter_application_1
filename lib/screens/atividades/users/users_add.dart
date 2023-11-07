import 'package:flutter/material.dart';

class UsersAdd extends StatefulWidget {
  const UsersAdd({super.key});

  @override
  State<UsersAdd> createState() => _UsersAddState();
}

class _UsersAddState extends State<UsersAdd> {
  
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Criar Usuário"),
        backgroundColor: const Color.fromARGB(255, 83, 245, 159),
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
                decoration: const InputDecoration(
                  labelText: "Nome",
                ),
              ),
              TextFormField(
                controller: _enderecoController,
                decoration: const InputDecoration(
                  labelText: "Endereço",
                ),
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(
                  labelText: "Telefone",
                ),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                ),
              ),
              const SizedBox(height: 20), // Espaço entre os campos
              ElevatedButton(
                  onPressed: () {
                    //_createUser();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 83, 245, 159)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("Criar Usuário")],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
