import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/pessoas.dart';
import 'package:flutter_application_1/screens/atividades/veiculos/veiculos_show.dart';
import 'package:flutter_application_1/screens/viagens/viagens_screen.dart';
import 'package:flutter_application_1/screens/conta/conta_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String id = "", nome = "", email = "", imagem = "", empresaId = "null";
  int _selectedNavItem = 0;

  Future<void> getDados() async {
    Pessoa user = Pessoa(empresaId: 'null');
    Pessoa pessoa = await user.getUserSession();
    setState(() {
      id = pessoa.id!;
      nome = pessoa.nome!;
      email = pessoa.email!;
      imagem = pessoa.imageUrl!;
      empresaId = pessoa.empresaId;
    });
  }

  @override
  void initState() {
    super.initState();
    getDados();
  }

  late List<Widget> _screens;

  void _updateScreens() {
    if (empresaId == 'null') {
      _screens = [
        ContaScreen(),
      ];
    } else {
      _screens = [
        const ViagensScreen(),
        const VeiculosShow(),
        ContaScreen(),
      ];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedNavItem = index;
    });
  }

  void _permissionDenied(int index) {
    if (index != 2) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Permissão negada"),
            content: const Text(
                "Não é possivel acessar esta funcionalidade sem estar vinculado a uma empresa!"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _checkPermission(int index) async {
    await getDados(); // Wait for getDados to complete
    if (empresaId == 'null') {
      _permissionDenied(index);
    } else {
      _onItemTapped(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateScreens();
    return Scaffold(
      body: _screens[_selectedNavItem],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.card_travel),
            label: 'Viagens',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Veículos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Conta',
          ),
        ],
        currentIndex: empresaId == 'null' ? 2 : _selectedNavItem,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _checkPermission,
      ),
    );
  }
}
