import 'package:sqflite/sqflite.dart';
import 'package:cep_facil/core/error/exceptions.dart';
import 'package:cep_facil/features/cep/data/models/cep_model.dart';

abstract interface class ICepLocalDatasource {
  Future<CepModel> getCep(String cep);

  Future<void> saveCep(CepModel model);
}

class CepLocalDatasourceImpl implements ICepLocalDatasource {
  const CepLocalDatasourceImpl(this._db);

  final Database _db;

  static const _table = 'ceps';

  @override
  Future<CepModel> getCep(String cep) async {
    final rows = await _db.query(_table, where: 'cep = ?', whereArgs: [cep], limit: 1);

    if (rows.isEmpty) throw const CacheException();

    return CepModel.fromMap(rows.first);
  }

  @override
  Future<void> saveCep(CepModel model) async {
    await _db.insert(_table, model.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
