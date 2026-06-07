import 'package:flutter_test/flutter_test.dart';
import 'package:cep_facil/core/utils/cep_validator.dart';

void main() {
  group('CepValidator', () {
    group('validate', () {
      test('deve retornar erro quando o valor é nulo', () {
        expect(CepValidator.validate(null), isNotNull);
      });

      test('deve retornar erro quando o valor está vazio', () {
        expect(CepValidator.validate(''), isNotNull);
      });

      test('deve retornar erro quando o CEP tem menos de 8 dígitos', () {
        expect(CepValidator.validate('1234567'), isNotNull);
      });

      test('deve retornar erro quando o CEP tem mais de 8 dígitos', () {
        expect(CepValidator.validate('123456789'), isNotNull);
      });

      test('deve retornar nulo para CEP válido com 8 dígitos', () {
        expect(CepValidator.validate('01310100'), isNull);
      });

      test('deve retornar nulo para CEP válido com máscara', () {
        expect(CepValidator.validate('01310-100'), isNull);
      });
    });

    group('sanitize', () {
      test('deve remover caracteres não numéricos', () {
        expect(CepValidator.unmask('01310-100'), '01310100');
      });

      test('deve retornar a mesma string quando já está limpa', () {
        expect(CepValidator.unmask('01310100'), '01310100');
      });
    });
  });
}
