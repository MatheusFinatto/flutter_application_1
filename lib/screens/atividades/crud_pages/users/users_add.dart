import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/pessoas.dart';

class UsersAdd extends StatefulWidget {
  const UsersAdd({super.key});

  @override
  State<UsersAdd> createState() => _UsersAddState();
}

class _UsersAddState extends State<UsersAdd> {
  // o id vai vir do proximo id do firebase, por enquanto é só um mock
  String _id = "0";
  String _cpf = "";
  String _nome = "";
  String _endereco = "";
  String _telefone = "";
  String _email = "";

  TextEditingController _idController = TextEditingController();
  TextEditingController _cpfController = TextEditingController();
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _enderecoController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  void _createUser(
      String cpf, String nome, String endereco, String telefone, String email) {
    int iId = int.parse(
      _id,
    );
    iId++;
    _id = iId.toString();
    Pessoa p1 = new Pessoa(
        id: _id,
        cpf: cpf,
        nome: nome,
        endereco: endereco,
        telefone: telefone,
        email: email);
    print(p1.nome + p1.id);
    
  }

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
                    _createUser(
                        _cpfController.text,
                        _nomeController.text,
                        _enderecoController.text,
                        _telefoneController.text,
                        _emailController.text);
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
