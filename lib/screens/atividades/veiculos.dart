import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/atividades/crud_pages/veiculos/veiculos_add.dart';
import 'package:flutter_application_1/screens/atividades/crud_pages/veiculos/veiculos_show.dart';
import 'package:flutter_application_1/screens/atividades/crud_pages/veiculos/veiculos_update.dart';
import 'package:flutter_application_1/screens/atividades/crud_pages/veiculos/veiculos_delete.dart';

class Veiculos extends StatefulWidget {
  const Veiculos({super.key});

  @override
  State<Veiculos> createState() => _VeiculosState();
}

class _VeiculosState extends State<Veiculos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Veículos")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 100.0, left: 20.0, right: 20.0, bottom: 25.0),
                  child: SizedBox(
                    width: 270,
                    height: 80,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const VeiculosShow()));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 217, 217, 217),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.directions_car,
                            size: 50,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Ver veículos",
                            style: TextStyle(
                              fontSize: 22,
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
                  padding: const EdgeInsets.only(
                      top: 25.0, left: 20.0, right: 20.0, bottom: 25.0),
                  child: SizedBox(
                    width: 270,
                    height: 80,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const VeiculosAdd()));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 217, 217, 217),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.add,
                              size: 50,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Novo Veículo",
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 25.0, left: 20.0, right: 20.0, bottom: 25.0),
                  child: SizedBox(
                    width: 270,
                    height: 80,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const VeiculosUpdate()));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 217, 217, 217),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.update,
                              size: 50,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Atualizar Veículo",
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 25.0, left: 20.0, right: 20.0, bottom: 25.0),
                  child: SizedBox(
                    width: 270,
                    height: 80,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const VeiculosDelete()));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 217, 217, 217),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.delete,
                              size: 50,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Deletar Veículo",
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
