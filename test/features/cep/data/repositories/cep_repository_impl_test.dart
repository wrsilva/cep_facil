import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cep_facil/core/error/exceptions.dart';
import 'package:cep_facil/core/error/failures.dart';
import 'package:cep_facil/features/cep/data/datasources/cep_local_datasource.dart';
import 'package:cep_facil/features/cep/data/datasources/cep_remote_datasource.dart';
import 'package:cep_facil/features/cep/data/models/cep_model.dart';
import 'package:cep_facil/features/cep/data/repositories/cep_repository_impl.dart';
import 'package:cep_facil/features/cep/domain/entities/cep_entity.dart';

class MockRemote extends Mock implements ICepRemoteDatasource {}

class MockLocal extends Mock implements ICepLocalDatasource {}

void main() {
  late MockRemote mockRemote;
  late MockLocal mockLocal;
  late CepRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(const CepModel(
      cep: '', logradouro: '', complemento: '', bairro: '', localidade: '', uf: '', ibge: '', ddd: '',
    ));
  });

  setUp(() {
    mockRemote = MockRemote();
    mockLocal = MockLocal();
    repository = CepRepositoryImpl(remoteDatasource: mockRemote, localDatasource: mockLocal);
  });

  const tCep = '01310100';
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

  group('CepRepositoryImpl', () {
    group('getCepFromCache', () {
      test('deve retornar entidade quando o datasource local tem sucesso', () async {
        when(() => mockLocal.getCep(tCep)).thenAnswer((_) async => tModel);

        final result = await repository.getCepFromCache(tCep);

        expect(result, isA<CepEntity>());
        expect(result.localidade, 'São Paulo');
        verifyNever(() => mockRemote.searchCep(any()));
      });

      test('deve lançar CacheFailure quando o datasource local não encontra o CEP', () {
        when(() => mockLocal.getCep(tCep)).thenThrow(const CacheException());

        expect(() => repository.getCepFromCache(tCep), throwsA(isA<CacheFailure>()));
      });
    });

    group('fetchCepFromRemote', () {
      test('deve retornar entidade quando o datasource remoto tem sucesso', () async {
        when(() => mockRemote.searchCep(tCep)).thenAnswer((_) async => tModel);

        final result = await repository.fetchCepFromRemote(tCep);

        expect(result, isA<CepEntity>());
        expect(result.localidade, 'São Paulo');
      });

      test('deve lançar ServerFailure quando o remoto lança ServerException', () {
        when(() => mockRemote.searchCep(tCep)).thenThrow(const ServerException('CEP não encontrado.'));

        expect(() => repository.fetchCepFromRemote(tCep), throwsA(isA<ServerFailure>()));
      });

      test('deve lançar NetworkFailure quando o remoto lança exceção genérica', () {
        when(() => mockRemote.searchCep(tCep)).thenThrow(Exception('network'));

        expect(() => repository.fetchCepFromRemote(tCep), throwsA(isA<NetworkFailure>()));
      });
    });

    group('saveToCache', () {
      test('deve salvar a entidade no datasource local', () async {
        when(() => mockLocal.saveCep(any())).thenAnswer((_) async {});

        await repository.saveToCache(tModel);

        verify(() => mockLocal.saveCep(any())).called(1);
      });
    });
  });
}
