import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/atividades/crud_pages/empresas/empresas_add.dart';
import 'package:flutter_application_1/screens/atividades/crud_pages/empresas/empresas_update.dart';
import 'package:flutter_application_1/screens/atividades/crud_pages/empresas/empresas_delete.dart';
class Empresas extends StatefulWidget {
  const Empresas({super.key});

  @override
  State<Empresas> createState() => _EmpresasState();
}

class _EmpresasState extends State<Empresas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Empresas")),
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
                              builder: (context) => const EmpresasAdd()));
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
                              "Nova Empresa",
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
                              builder: (context) => const EmpresasUpdate()));
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
                              "Atualizar Empresa",
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
                              builder: (context) => const EmpresasDelete()));
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
                              "Deletar Empresa",
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
