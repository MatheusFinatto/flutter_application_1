import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Pessoa {
  final String? id;
  final String? cpf;
  final String? nome;
  final String? endereco;
  final String? telefone;
  final String? email;
  final String? imageUrl;
  final String empresaId;

  Pessoa({
    this.id,
    this.cpf,
    this.nome,
    this.endereco,
    this.telefone,
    this.email,
    this.imageUrl,
    required this.empresaId,
  });

  factory Pessoa.fromMap(Map<String, dynamic> map) {
    return Pessoa(
      id: map['id'],
      cpf: map['cpf'],
      nome: map['nome'],
      endereco: map['endereco'],
      telefone: map['telefone'],
      email: map['email'],
      imageUrl: map['imageUrl'],
      empresaId: map['empresaId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cpf': cpf,
      'nome': nome,
      'endereco': endereco,
      'telefone': telefone,
      'email': email,
      'imageUrl': imageUrl,
      'empresaId': empresaId,
    };
  }

  Future<Pessoa> getUserSession() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    DocumentSnapshot snapshot =
        await db.collection("pessoas").doc(user!.uid).get();
    Map<String, dynamic>? dado = snapshot.data() as Map<String, dynamic>?;

    String endereco = '';
    String telefone = '';
    String imageUrl = '';
    if (dado != null) {
      String id = user.uid;
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
      dado['empresaId'] ?? (dado['empresaId'] = 'null');

      return Pessoa(
        id: id,
        cpf: cpf,
        nome: nome,
        endereco: endereco,
        telefone: telefone,
        email: email,
        imageUrl: imageUrl,
        empresaId: dado['empresaId'],
      );
    } else {
      throw Exception('Dados não encontrados no Firestore.');
    }
  }
}
