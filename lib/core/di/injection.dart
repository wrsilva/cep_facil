import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:cep_facil/core/network/dio_client.dart';
import 'package:cep_facil/core/theme/theme_cubit.dart';
import 'package:cep_facil/features/cep/data/datasources/cep_local_datasource.dart';
import 'package:cep_facil/features/cep/data/datasources/cep_remote_datasource.dart';
import 'package:cep_facil/features/cep/data/repositories/cep_repository_impl.dart';
import 'package:cep_facil/features/cep/domain/repositories/i_cep_repository.dart';
import 'package:cep_facil/features/cep/domain/usecases/search_cep_usecase.dart';
import 'package:cep_facil/features/cep/presentation/cubits/cep_cubit.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  // Logging
  sl.registerLazySingleton<Talker>(TalkerFlutter.init);

  // Database
  final db = await _openDatabase();
  sl.registerSingleton<Database>(db);

  // Network
  sl.registerLazySingleton(() => DioClient.create(talker: sl()));

  // Datasources
  sl.registerLazySingleton<ICepRemoteDatasource>(() => CepRemoteDatasourceImpl(sl()));
  sl.registerLazySingleton<ICepLocalDatasource>(() => CepLocalDatasourceImpl(sl()));

  // Repository
  sl.registerLazySingleton<ICepRepository>(() => CepRepositoryImpl(remoteDatasource: sl(), localDatasource: sl()));

  // Usecases
  sl.registerFactory(() => SearchCepUsecase(sl()));

  // Cubits
  sl.registerFactory(() => CepCubit(sl()));
  sl.registerLazySingleton(() => ThemeCubit());
}

Future<Database> _openDatabase() async {
  final dbPath = await getDatabasesPath();
  return openDatabase(
    path.join(dbPath, 'cep_facil.db'),
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
  );
}
