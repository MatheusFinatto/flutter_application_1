import 'package:flutter_application_1/models/pessoas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Pessoas {
  Future<Pessoa> getUserSession() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = await auth.currentUser;

    if (user == null) {
      throw Exception('No user is currently logged in.');
    }

    DocumentSnapshot snapshot =
        await db.collection("pessoas").doc(user.uid).get();
    Map<String, dynamic>? dado = snapshot.data() as Map<String, dynamic>?;

    String endereco = '';
    String telefone = '';
    String imageUrl = '';
    if (dado != null) {
      String id = user.uid; // User's document ID
      String cpf = dado['cpf'];
      String nome = dado['nome'];
      String email = dado['email'];
      if (dado['endereco'] != null) {
        endereco = dado['endereco'];
      }
      if (dado['telefone'] != null) {
        telefone = dado['telefone'];
      }
      if (dado['imageUrl'] != null) {
        imageUrl = dado['imageUrl'];
      }

      // Return the user's document ID and Pessoa object as a map
      return Pessoa(
        id: id,
        cpf: cpf,
        nome: nome,
        endereco: endereco,
        telefone: telefone,
        email: email,
        imageUrl: imageUrl,
      );
    } else {
      throw Exception('Dados não encontrados no Firestore.');
    }
  }
}

List<Pessoa> pessoasList = [
  Pessoa(
    id: '1',
    cpf: '111.111.111-11',
    nome: 'Ednaldo Pereira',
    endereco: '123 Main St, City',
    telefone: '555-555-5555',
    email: 'ednaldo@example.com',
    imageUrl: '',
  ),
  Pessoa(
    id: '2',
    cpf: '222.222.222-22',
    nome: 'Irineu',
    endereco: '456 Elm St, Town',
    telefone: '555-123-4567',
    email: 'irineu@example.com',
    imageUrl: '',
  ),
  Pessoa(
    id: '3',
    cpf: '444.444.444-44',
    nome: 'Vin Diesel Brasileiro',
    endereco: '101 Pine St, Hamlet',
    telefone: '555-111-3333',
    email: 'vin@example.com',
    imageUrl: 'assets/images/vinDieselBr.png',
  ),
  Pessoa(
    id: '3',
    cpf: '555.555.555-55',
    nome: 'Rick Astley',
    endereco: '987 Never Gonna Give You Up St',
    telefone: "9555-3456",
    email: "rickastley@example.com",
    imageUrl: 'assets/images/vinDieselBr.png',
  ),
];
