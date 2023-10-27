import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContaScreen extends StatefulWidget {
  const ContaScreen({Key? key}) : super(key: key);

  @override
  ContaScreenState createState() => ContaScreenState();
}

class ContaScreenState extends State<ContaScreen> {
  // ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conta'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _fetchPessoaData(), // Fetch pessoa data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Text('No pessoa data found.');
          }

          final pessoaData = snapshot.data!.data() as Map<String, dynamic>;
          return Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 20, left: 40, top: 16, right: 40),
                child: Row(
                  // Display pessoa data
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          pessoaData['nome'],
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w900),
                        ),
                        Text(
                          pessoaData['cpf'],
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    ClipOval(
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(
                        pessoaData['imagemUrl'] ??
                            'https://ojasyog.com/wp-content/uploads/2022/02/421-4212617_person-placeholder-image-transparent-hd-png-download.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.fill,
                      ),
                    )
                  ],
                ),
              ),

              // Rest of your UI elements
              ListView(
                shrinkWrap: true,
                children: const <Widget>[
                  ListTile(
                    leading: Icon(Icons.corporate_fare_sharp),
                    title: Text(
                      'Empresa',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text(
                      'Alterar dados',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text(
                      'Configurações',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 40, left: 10),
                    child: ListTile(
                      title: Text(
                        'Encerrar sessão',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Future<DocumentSnapshot> _fetchPessoaData() async {
    try {
      return await FirebaseFirestore.instance
          .doc('pessoas/rKS4uej8PQwbIkxRLjWD')
          .get();
    } catch (e) {
      print('Error fetching pessoa data: $e');
      throw e;
    }
  }
}
