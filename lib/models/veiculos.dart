class Veiculo {
  final String id;
  final String marca;
  final String modelo;
  final String placa;
  final String ano;
  final String capacidade;
  final String imageUrl;

  Veiculo({
    required this.id,
    required this.marca,
    required this.modelo,
    required this.placa,
    required this.ano,
    required this.capacidade,
    required this.imageUrl,
  });
}

final List<Veiculo> veiculosList = [
  Veiculo(
    id: 'uno',
    marca: 'Fiat',
    modelo: 'Uno',
    placa: 'ABC1234',
    ano: '2020',
    capacidade: '5',
    imageUrl: 'assets/images/uno.png',
  ),
  Veiculo(
    id: 'palio',
    marca: 'Fiat',
    modelo: 'Palio',
    placa: 'DEF5678',
    ano: '2021',
    capacidade: '5',
    imageUrl: 'assets/images/palio.png',
  ),
  Veiculo(
    id: 'mobi',
    marca: 'Fiat',
    modelo: 'Mobi',
    placa: 'GHI9012',
    ano: '2022',
    capacidade: '5',
    imageUrl: 'assets/images/mobi.png',
  ),
  Veiculo(
    id: 'mustang',
    marca: 'Ford',
    modelo: 'Mustang',
    placa: 'JKL3456',
    ano: '2020',
    capacidade: '4',
    imageUrl: 'assets/images/mustang.png',
  ),
  Veiculo(
    id: 'corolla',
    marca: 'Toyota',
    modelo: 'Corolla',
    placa: 'MNO7890',
    ano: '2021',
    capacidade: '5',
    imageUrl: 'assets/images/corolla.png',
  ),
  Veiculo(
    id: 'f40',
    marca: 'Ferrari',
    modelo: 'F40',
    placa: 'PQR1234',
    ano: '2021',
    capacidade: '2',
    imageUrl: 'assets/images/f40.png',
  ),
];
