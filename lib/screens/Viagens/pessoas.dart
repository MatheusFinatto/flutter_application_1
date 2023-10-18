class Pessoa {
  final String cpf;
  final String nome;
  final String endereco;
  final String telefone;
  final String email;

  Pessoa({
    required this.cpf,
    required this.nome,
    required this.endereco,
    required this.telefone,
    required this.email,
  });
}

final List<Pessoa> pessoasList = [
  Pessoa(
    cpf: '111.111.111-11',
    nome: 'Ednaldo Pereira',
    endereco: '123 Main St, City',
    telefone: '555-555-5555',
    email: 'ednaldo@example.com',
  ),
  Pessoa(
    cpf: '222.222.222-22',
    nome: 'Irineu',
    endereco: '456 Elm St, Town',
    telefone: '555-123-4567',
    email: 'irineu@example.com',
  ),
  Pessoa(
    cpf: '333.333.333-33',
    nome: 'Dipirono Mussarelo',
    endereco: '789 Oak St, Village',
    telefone: '555-987-6543',
    email: 'dipirono@example.com',
  ),
  Pessoa(
    cpf: '444.444.444-44',
    nome: 'Vin Diesel Brasileiro',
    endereco: '101 Pine St, Hamlet',
    telefone: '555-111-3333',
    email: 'vin@example.com',
  ),
  Pessoa(
    cpf: '555.555.555-55',
    nome: 'Dilera Tourettes',
    endereco: '246 Cedar St, County',
    telefone: '555-999-0000',
    email: 'dilera@example.com',
  ),
];
