import 'package:cep_facil/features/cep/domain/entities/cep_entity.dart';

class CepModel extends CepEntity {
  const CepModel({
    required super.cep,
    required super.logradouro,
    required super.complemento,
    required super.bairro,
    required super.localidade,
    required super.uf,
    required super.ibge,
    required super.ddd,
  });

  factory CepModel.fromJson(Map<String, dynamic> json) {
    return CepModel(
      cep: json['cep'] as String? ?? '',
      logradouro: json['logradouro'] as String? ?? '',
      complemento: json['complemento'] as String? ?? '',
      bairro: json['bairro'] as String? ?? '',
      localidade: json['localidade'] as String? ?? '',
      uf: json['uf'] as String? ?? '',
      ibge: json['ibge'] as String? ?? '',
      ddd: json['ddd'] as String? ?? '',
    );
  }

  factory CepModel.fromMap(Map<String, dynamic> map) {
    return CepModel(
      cep: map['cep'] as String,
      logradouro: map['logradouro'] as String,
      complemento: map['complemento'] as String,
      bairro: map['bairro'] as String,
      localidade: map['localidade'] as String,
      uf: map['uf'] as String,
      ibge: map['ibge'] as String,
      ddd: map['ddd'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
    'cep': cep,
    'logradouro': logradouro,
    'complemento': complemento,
    'bairro': bairro,
    'localidade': localidade,
    'uf': uf,
    'ibge': ibge,
    'ddd': ddd,
  };

  CepEntity toEntity() =>
      CepEntity(cep: cep, logradouro: logradouro, complemento: complemento, bairro: bairro, localidade: localidade, uf: uf, ibge: ibge, ddd: ddd);
}
