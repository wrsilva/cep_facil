import 'package:cep_facil/features/cep/domain/entities/cep_entity.dart';

abstract interface class ICepRepository {
  Future<CepEntity> getCepFromCache(String cep);
  Future<CepEntity> fetchCepFromRemote(String cep);
  Future<void> saveToCache(CepEntity entity);
}
