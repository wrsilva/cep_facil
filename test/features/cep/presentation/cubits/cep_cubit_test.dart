import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cep_facil/core/error/failures.dart';
import 'package:cep_facil/features/cep/domain/entities/cep_entity.dart';
import 'package:cep_facil/features/cep/domain/usecases/search_cep_usecase.dart';
import 'package:cep_facil/features/cep/presentation/cubits/cep_cubit.dart';
import 'package:cep_facil/features/cep/presentation/cubits/cep_state.dart';

class MockSearchCepUsecase extends Mock implements SearchCepUsecase {}

void main() {
  late MockSearchCepUsecase mockUsecase;
  late CepCubit cubit;

  setUp(() {
    mockUsecase = MockSearchCepUsecase();
    cubit = CepCubit(mockUsecase);
  });

  tearDown(() => cubit.close());

  const tCep = '01310100';
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

  group('CepCubit', () {
    test('estado inicial deve ser CepInitial', () {
      expect(cubit.state, isA<CepInitial>());
    });

    blocTest<CepCubit, CepState>(
      'deve emitir [CepLoading, CepSuccess] quando searchCep tem sucesso',
      build: () {
        when(() => mockUsecase(tCep)).thenAnswer((_) async => tEntity);
        return CepCubit(mockUsecase);
      },
      act: (cubit) => cubit.searchCep(tCep),
      expect: () => [
        isA<CepLoading>(),
        isA<CepSuccess>().having((s) => s.entity, 'entity', tEntity),
      ],
    );

    blocTest<CepCubit, CepState>(
      'deve emitir [CepLoading, CepFailure] quando o usecase lança ServerFailure',
      build: () {
        when(() => mockUsecase(tCep))
            .thenThrow(const ServerFailure('CEP não encontrado.'));
        return CepCubit(mockUsecase);
      },
      act: (cubit) => cubit.searchCep(tCep),
      expect: () => [
        isA<CepLoading>(),
        isA<CepFailure>().having(
          (s) => s.message,
          'message',
          'CEP não encontrado.',
        ),
      ],
    );

    blocTest<CepCubit, CepState>(
      'deve emitir [CepLoading, CepFailure] quando o usecase lança NetworkFailure',
      build: () {
        when(() => mockUsecase(tCep)).thenThrow(const NetworkFailure());
        return CepCubit(mockUsecase);
      },
      act: (cubit) => cubit.searchCep(tCep),
      expect: () => [
        isA<CepLoading>(),
        isA<CepFailure>().having(
          (s) => s.message,
          'message',
          contains('internet'),
        ),
      ],
    );

    blocTest<CepCubit, CepState>(
      'deve emitir [CepLoading, CepFailure] ao ocorrer exceção inesperada',
      build: () {
        when(() => mockUsecase(tCep)).thenThrow(Exception('unexpected'));
        return CepCubit(mockUsecase);
      },
      act: (cubit) => cubit.searchCep(tCep),
      expect: () => [
        isA<CepLoading>(),
        isA<CepFailure>(),
      ],
    );
  });
}
