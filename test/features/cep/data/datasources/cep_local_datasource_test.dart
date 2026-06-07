import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:cep_facil/core/error/exceptions.dart';
import 'package:cep_facil/features/cep/data/datasources/cep_local_datasource.dart';
import 'package:cep_facil/features/cep/data/models/cep_model.dart';

void main() {
  late Database db;
  late CepLocalDatasourceImpl datasource;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    db = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE ceps (
              cep TEXT PRIMARY KEY,
              logradouro TEXT NOT NULL,
              complemento TEXT NOT NULL,
              bairro TEXT NOT NULL,
              localidade TEXT NOT NULL,
              uf TEXT NOT NULL,
              ibge TEXT NOT NULL,
              ddd TEXT NOT NULL
            )
          ''');
        },
      ),
    );
    datasource = CepLocalDatasourceImpl(db);
  });

  tearDown(() async => db.close());

  const tModel = CepModel(
    cep: '01310100',
    logradouro: 'Avenida Paulista',
    complemento: '',
    bairro: 'Bela Vista',
    localidade: 'São Paulo',
    uf: 'SP',
    ibge: '3550308',
    ddd: '11',
  );

  group('CepLocalDatasource', () {
    group('saveCep', () {
      test('deve inserir o CEP no banco de dados com a chave exata recebida', () async {
        await datasource.saveCep(tModel);
        final rows = await db.query('ceps');
        expect(rows.length, 1);
        expect(rows.first['cep'], '01310100');
      });

      test('deve substituir ao conflito com o mesmo CEP', () async {
        await datasource.saveCep(tModel);
        await datasource.saveCep(tModel);
        final rows = await db.query('ceps');
        expect(rows.length, 1);
      });
    });

    group('getCep', () {
      test('deve retornar CepModel quando a chave existe no banco', () async {
        await datasource.saveCep(tModel);
        final result = await datasource.getCep('01310100');
        expect(result.localidade, 'São Paulo');
      });

      test('deve lançar CacheException quando o CEP não for encontrado', () async {
        expect(
          () => datasource.getCep('00000000'),
          throwsA(isA<CacheException>()),
        );
      });
    });
  });
}
