import 'dart:io';
import 'dart:convert';

import 'package:flutter_application_1/Endereco.dart';

class ConsultaCep {
  static Future<Endereco> fetchCep(String cep) async {
    print("Processando...");

    final client = HttpClient();

    final req = await client.getUrl(
      Uri.parse('https://viacep.com.br/ws/$cep/json/'),
    );

    final res = await req.close();

    final body = await res.transform(utf8.decoder).join();

    client.close();

    final data = jsonDecode(body) as Map<String, dynamic>;

    if (data.containsKey('erro')) {
      throw Exception('CEP não encontrado');
    }

    return _paraResponse(body);
  }

  static Endereco _paraResponse(String body) {
    final data = jsonDecode(body) as Map<String, dynamic>;

    return Endereco.fromJson(data);
  }
}