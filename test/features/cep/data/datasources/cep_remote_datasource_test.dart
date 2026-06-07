import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cep_facil/core/error/exceptions.dart';
import 'package:cep_facil/features/cep/data/datasources/cep_remote_datasource.dart';
import 'package:cep_facil/features/cep/data/models/cep_model.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late CepRemoteDatasourceImpl datasource;

  setUp(() {
    mockDio = MockDio();
    datasource = CepRemoteDatasourceImpl(mockDio);
  });

  const tCep = '01310100';

  final tResponseData = <String, dynamic>{
    'cep': '01310-100',
    'logradouro': 'Avenida Paulista',
    'complemento': '',
    'bairro': 'Bela Vista',
    'localidade': 'São Paulo',
    'uf': 'SP',
    'ibge': '3550308',
    'ddd': '11',
  };

  group('CepRemoteDatasource', () {
    test('deve retornar CepModel quando o status é 200 e não há campo erro', () async {
      when(() => mockDio.get('$tCep/json/')).thenAnswer(
        (_) async => Response(
          data: tResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '$tCep/json/'),
        ),
      );

      final result = await datasource.searchCep(tCep);

      expect(result, isA<CepModel>());
      expect(result.cep, '01310-100');
      expect(result.localidade, 'São Paulo');
    });

    test('deve lançar ServerException quando a resposta contém o campo "erro"', () {
      when(() => mockDio.get('$tCep/json/')).thenAnswer(
        (_) async => Response(
          data: {'erro': 'true'},
          statusCode: 200,
          requestOptions: RequestOptions(path: '$tCep/json/'),
        ),
      );

      expect(
        () => datasource.searchCep(tCep),
        throwsA(isA<ServerException>()),
      );
    });

    test('deve lançar ServerException ao ocorrer DioException', () {
      when(() => mockDio.get('$tCep/json/')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '$tCep/json/'),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      expect(
        () => datasource.searchCep(tCep),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
