import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/conta/dados_empresa.dart';

class ContaScreen extends StatefulWidget {
  const ContaScreen({Key? key}) : super(key: key);

  @override
  ContaScreenState createState() => ContaScreenState();
}

class ContaScreenState extends State<ContaScreen> {
  // @override
  // void initState() {
  //   super.initState();
  // }
  static const List<Widget> _screens = [Dados_EmpresaScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conta'),
      ),
      body: Column(
        children: [
          // Search input field
          const Padding(
            padding: EdgeInsets.only(bottom: 20, left: 20, top: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Nome do Funcionario',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                    Text(
                      '#12313213',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Icon(Icons.person, size: 50),
              ],
            ),
          ),
          ListView(
            shrinkWrap: true,
            children: const <Widget>[
              ListTile(
                leading: Icon(Icons.corporate_fare_sharp),
                title: Text(
                  'Empresa',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  'Alterar dados',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text(
                  'Configurações',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 40, left: 10),
                  child: ListTile(
                    title: Text(
                      'Encerrar sessão',
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
