class Pessoa {
  final String id;
  final String cpf;
  final String nome;
  final String endereco;
  final String telefone;
  final String email;
  final String imageUrl;

  Pessoa({
    required this.id,
    required this.cpf,
    required this.nome,
    required this.endereco,
    required this.telefone,
    required this.email,
    required this.imageUrl,
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
    };
  }
}
