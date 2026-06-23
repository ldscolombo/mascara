import 'dart:io';

String removerMascaraCEP(String cepFormatado) {
  return cepFormatado.replaceAll(RegExp(r'[^0-9]'), '');
}

String aplicarMascaraCEP(String cepLimpo) {
  if (cepLimpo.length != 8) {
    throw Exception('CEP inválido! Deve conter 8 dígitos.');
  }

  return '${cepLimpo.substring(0, 5)}-${cepLimpo.substring(5)}';
}

void main() {
  stdout.write('Digite o CEP: ');
  String? cepDigitado = stdin.readLineSync();

  if (cepDigitado == null || cepDigitado.isEmpty) {
    print('CEP inválido!');
    return;
  }

  String cepLimpo = removerMascaraCEP(cepDigitado);

  if (cepLimpo.length != 8) {
    print('CEP inválido! Deve conter 8 dígitos.');
    return;
  }

  String cepComMascara = aplicarMascaraCEP(cepLimpo);

  print('\nCEP Formatado: $cepComMascara');
  print('CEP para Consulta: $cepLimpo');
}