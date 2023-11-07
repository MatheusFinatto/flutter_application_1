class Veiculo {
  String? uid;
  final String marca;
  final String modelo;
  final String placa;
  final String ano;
  final int capacidade;
  final String imageUrl;

  Veiculo({
    this.uid,
    required this.marca,
    required this.modelo,
    required this.placa,
    required this.ano,
    required this.capacidade,
    required this.imageUrl,
  });

  factory Veiculo.fromMap(Map<String, dynamic> map) {
    print("Veiculo.fromMap - Received data: $map");
    return Veiculo(
      uid: map['uid'],
      marca: map['marca'],
      modelo: map['modelo'],
      placa: map['placa'],
      ano: map['ano'],
      capacidade: map['capacidade'],
      imageUrl: map['imageUrl'],
    );
  }

  // Define the toJson method to convert the Veiculo object to a JSON format.
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'marca': marca,
      'modelo': modelo,
      'placa': placa,
      'ano': ano,
      'capacidade': capacidade,
      'imageUrl': imageUrl,
    };
  }
}
