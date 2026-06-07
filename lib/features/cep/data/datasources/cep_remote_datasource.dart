import 'package:dio/dio.dart';
import 'package:cep_facil/core/error/exceptions.dart';
import 'package:cep_facil/features/cep/data/models/cep_model.dart';

abstract interface class ICepRemoteDatasource {
  Future<CepModel> searchCep(String cep);
}

class CepRemoteDatasourceImpl implements ICepRemoteDatasource {
  const CepRemoteDatasourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<CepModel> searchCep(String cep) async {
    try {
      final response = await _dio.get('$cep/json/');
      final data = response.data as Map<String, dynamic>;

      if (data.containsKey('erro')) {
        throw const ServerException('CEP não encontrado.');
      }

      return CepModel.fromJson(data);
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Erro de conexão com o servidor.');
    }
  }
}
