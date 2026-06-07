import 'package:cep_facil/core/error/exceptions.dart';
import 'package:cep_facil/core/error/failures.dart';
import 'package:cep_facil/features/cep/data/datasources/cep_local_datasource.dart';
import 'package:cep_facil/features/cep/data/datasources/cep_remote_datasource.dart';
import 'package:cep_facil/features/cep/data/models/cep_model.dart';
import 'package:cep_facil/features/cep/domain/entities/cep_entity.dart';
import 'package:cep_facil/features/cep/domain/repositories/i_cep_repository.dart';

class CepRepositoryImpl implements ICepRepository {
  const CepRepositoryImpl({required this.remoteDatasource, required this.localDatasource});

  final ICepRemoteDatasource remoteDatasource;
  final ICepLocalDatasource localDatasource;

  @override
  Future<CepEntity> getCepFromCache(String cep) async {
    try {
      return await localDatasource.getCep(cep);
    } on CacheException {
      throw const CacheFailure();
    }
  }

  @override
  Future<CepEntity> fetchCepFromRemote(String cep) async {
    try {
      return await remoteDatasource.searchCep(cep);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> saveToCache(CepEntity entity) async {
    await localDatasource.saveCep(
      CepModel(
        cep: entity.cep,
        logradouro: entity.logradouro,
        complemento: entity.complemento,
        bairro: entity.bairro,
        localidade: entity.localidade,
        uf: entity.uf,
        ibge: entity.ibge,
        ddd: entity.ddd,
      ),
    );
  }
}
