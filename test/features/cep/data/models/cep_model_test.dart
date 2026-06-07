import 'package:flutter_test/flutter_test.dart';
import 'package:cep_facil/features/cep/data/models/cep_model.dart';
import 'package:cep_facil/features/cep/domain/entities/cep_entity.dart';

void main() {
  const tModel = CepModel(
    cep: '01310-100',
    logradouro: 'Avenida Paulista',
    complemento: '',
    bairro: 'Bela Vista',
    localidade: 'São Paulo',
    uf: 'SP',
    ibge: '3550308',
    ddd: '11',
  );

  const tJson = <String, dynamic>{
    'cep': '01310-100',
    'logradouro': 'Avenida Paulista',
    'complemento': '',
    'bairro': 'Bela Vista',
    'localidade': 'São Paulo',
    'uf': 'SP',
    'ibge': '3550308',
    'ddd': '11',
  };

  group('CepModel', () {
    test('deve ser uma subclasse de CepEntity', () {
      expect(tModel, isA<CepEntity>());
    });

    group('fromJson', () {
      test('deve parsear todos os campos corretamente', () {
        final result = CepModel.fromJson(tJson);
        expect(result, tModel);
      });

      test('deve tratar complemento nulo como string vazia', () {
        final json = Map<String, dynamic>.from(tJson)
          ..['complemento'] = null;
        final result = CepModel.fromJson(json);
        expect(result.complemento, '');
      });
    });

    group('toMap / fromMap (SQLite)', () {
      test('toMap deve retornar o mapa correto', () {
        final map = tModel.toMap();
        expect(map['cep'], '01310-100');
        expect(map['logradouro'], 'Avenida Paulista');
        expect(map['bairro'], 'Bela Vista');
        expect(map['localidade'], 'São Paulo');
        expect(map['uf'], 'SP');
      });

      test('fromMap deve reconstruir o modelo a partir de uma linha do SQLite', () {
        final result = CepModel.fromMap(tModel.toMap());
        expect(result, tModel);
      });
    });

    group('toEntity', () {
      test('deve retornar CepEntity com os mesmos dados', () {
        final entity = tModel.toEntity();
        expect(entity.cep, tModel.cep);
        expect(entity.logradouro, tModel.logradouro);
        expect(entity, isA<CepEntity>());
      });
    });
  });
}
