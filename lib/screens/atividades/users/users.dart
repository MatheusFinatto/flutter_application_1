import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/atividades/users/users_add.dart';
import 'package:flutter_application_1/screens/atividades/users/users_update.dart';
import 'package:flutter_application_1/screens/atividades/users/users_delete.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Usuários")),
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
                                  builder: (context) => const UsersAdd()));
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
                              "Novo Usuário",
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
                                  builder: (context) => const UsersUpdate()));
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
                              "Atualizar Usuário",
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
                                  builder: (context) => const UsersDelete()));
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
                              "Deletar Usuário",
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
