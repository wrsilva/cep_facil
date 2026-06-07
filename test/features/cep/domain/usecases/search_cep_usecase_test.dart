import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cep_facil/core/error/failures.dart';
import 'package:cep_facil/features/cep/domain/entities/cep_entity.dart';
import 'package:cep_facil/features/cep/domain/repositories/i_cep_repository.dart';
import 'package:cep_facil/features/cep/domain/usecases/search_cep_usecase.dart';

class MockICepRepository extends Mock implements ICepRepository {}

void main() {
  late MockICepRepository mockRepository;
  late SearchCepUsecase usecase;

  setUpAll(() {
    registerFallbackValue(const CepEntity(
      cep: '', logradouro: '', complemento: '', bairro: '', localidade: '', uf: '', ibge: '', ddd: '',
    ));
  });

  setUp(() {
    mockRepository = MockICepRepository();
    usecase = SearchCepUsecase(mockRepository);
  });

  const tCepSanitizado = '01310100';
  const tCepComMascara = '01310-100';
  const tEntity = CepEntity(
    cep: '01310-100',
    logradouro: 'Avenida Paulista',
    complemento: '',
    bairro: 'Bela Vista',
    localidade: 'São Paulo',
    uf: 'SP',
    ibge: '3550308',
    ddd: '11',
  );

  group('SearchCepUsecase', () {
    test('deve retornar entidade do cache sem chamar o remoto', () async {
      when(() => mockRepository.getCepFromCache(tCepSanitizado))
          .thenAnswer((_) async => tEntity);

      final result = await usecase(tCepSanitizado);

      expect(result, tEntity);
      verifyNever(() => mockRepository.fetchCepFromRemote(any()));
      verifyNever(() => mockRepository.saveToCache(any()));
    });

    test('deve sanitizar o CEP com máscara antes de consultar', () async {
      when(() => mockRepository.getCepFromCache(tCepSanitizado))
          .thenAnswer((_) async => tEntity);

      await usecase(tCepComMascara);

      verify(() => mockRepository.getCepFromCache(tCepSanitizado)).called(1);
    });

    test('deve buscar no remoto e salvar no cache quando não encontrado localmente', () async {
      when(() => mockRepository.getCepFromCache(tCepSanitizado))
          .thenThrow(const CacheFailure());
      when(() => mockRepository.fetchCepFromRemote(tCepSanitizado))
          .thenAnswer((_) async => tEntity);
      when(() => mockRepository.saveToCache(any())).thenAnswer((_) async {});

      final result = await usecase(tCepSanitizado);

      expect(result, tEntity);
      verify(() => mockRepository.fetchCepFromRemote(tCepSanitizado)).called(1);
      final captured = verify(() => mockRepository.saveToCache(captureAny())).captured;
      final savedEntity = captured.first as CepEntity;
      expect(savedEntity.cep, tCepSanitizado);
      expect(savedEntity.localidade, tEntity.localidade);
    });

    test('deve relançar ServerFailure quando o remoto falha com CEP inválido', () {
      when(() => mockRepository.getCepFromCache(tCepSanitizado))
          .thenThrow(const CacheFailure());
      when(() => mockRepository.fetchCepFromRemote(tCepSanitizado))
          .thenThrow(const ServerFailure('CEP não encontrado.'));

      expect(() => usecase(tCepSanitizado), throwsA(isA<ServerFailure>()));
    });

    test('deve relançar NetworkFailure quando não há conexão', () {
      when(() => mockRepository.getCepFromCache(tCepSanitizado))
          .thenThrow(const CacheFailure());
      when(() => mockRepository.fetchCepFromRemote(tCepSanitizado))
          .thenThrow(const NetworkFailure());

      expect(() => usecase(tCepSanitizado), throwsA(isA<NetworkFailure>()));
    });
  });
}
