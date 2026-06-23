class Endereco {
  final String cep;
  final String logradouro;
  final String bairro;
  final String localidade;
  final String uf;

  const Endereco({
    required this.cep,
    required this.logradouro,
    required this.bairro,
    required this.localidade,
    required this.uf,
  });

  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      cep: json['cep'] ?? '',
      logradouro: json['logradouro'] ?? '',
      bairro: json['bairro'] ?? '',
      localidade: json['localidade'] ?? '',
      uf: json['uf'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'cep': cep,
        'logradouro': logradouro,
        'bairro': bairro,
        'localidade': localidade,
        'uf': uf,
      };

  String get enderecoFormatado {
    final partes = [logradouro, bairro];

    return '${partes.join(', ')} — $localidade/$uf, CEP $cep';
  }

  @override
  String toString() => enderecoFormatado;
}