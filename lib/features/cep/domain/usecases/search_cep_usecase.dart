import 'package:cep_facil/core/error/failures.dart';
import 'package:cep_facil/core/utils/cep_validator.dart';
import 'package:cep_facil/features/cep/domain/entities/cep_entity.dart';
import 'package:cep_facil/features/cep/domain/repositories/i_cep_repository.dart';

class SearchCepUsecase {
  const SearchCepUsecase(this._repository);

  final ICepRepository _repository;

  Future<CepEntity> call(String cep) async {
    final sanitized = CepValidator.unmask(cep);
    try {
      return await _repository.getCepFromCache(sanitized);
    } on CacheFailure {
      final entity = await _repository.fetchCepFromRemote(sanitized);
      await _repository.saveToCache(entity.copyWith(cep: sanitized));
      return entity;
    }
  }
}
