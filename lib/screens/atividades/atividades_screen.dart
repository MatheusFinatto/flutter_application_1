import 'package:flutter/material.dart';
import 'users.dart';
import 'veiculos.dart';
import 'empresas.dart';

class AtividadesScreen extends StatefulWidget {
  const AtividadesScreen({super.key});

  @override
  State<AtividadesScreen> createState() => _ServicesHomeState();
}

class _ServicesHomeState extends State<AtividadesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Atividades"),
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // titulo
              // users
              // viagens
              // veiculos
              // empresas
              const Padding(
                padding:
                    EdgeInsets.only(left: 18, right: 18, top: 50, bottom: 50),
                child: Text(
                  "Atividades",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, 
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: SizedBox(
                      width: 250,
                      height: 80, 
                      child: ElevatedButton(
                        // Usuários
                        onPressed: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Users()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 217, 217, 217),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.person,
                              size: 50,
                            ),
                            SizedBox(
                              width: 8, 
                            ),
                            Text(
                              "Usuários",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: SizedBox(
                      width: 250,
                      height: 80, 
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Veiculos()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 217, 217, 217),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.directions_car,
                              size: 50,
                            ),
                            SizedBox(
                              width: 8, // Espaçamento entre o ícone e o rótulo
                            ),
                            Text(
                              "Veículos",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: SizedBox(
                      width: 250,
                      height: 80, // Defina a largura desejada aqui
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Empresas()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 217, 217, 217),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.business,
                              size: 50,
                            ),
                            SizedBox(
                                width:
                                    8), // Espaçamento entre o ícone e o rótulo
                            Text(
                              "Empresas",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
