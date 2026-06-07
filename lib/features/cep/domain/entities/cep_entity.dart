import 'package:equatable/equatable.dart';

class CepEntity extends Equatable {
  const CepEntity({
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.bairro,
    required this.localidade,
    required this.uf,
    required this.ibge,
    required this.ddd,
  });

  final String cep;
  final String logradouro;
  final String complemento;
  final String bairro;
  final String localidade;
  final String uf;
  final String ibge;
  final String ddd;

  CepEntity copyWith({
    String? cep,
    String? logradouro,
    String? complemento,
    String? bairro,
    String? localidade,
    String? uf,
    String? ibge,
    String? ddd,
  }) => CepEntity(
    cep: cep ?? this.cep,
    logradouro: logradouro ?? this.logradouro,
    complemento: complemento ?? this.complemento,
    bairro: bairro ?? this.bairro,
    localidade: localidade ?? this.localidade,
    uf: uf ?? this.uf,
    ibge: ibge ?? this.ibge,
    ddd: ddd ?? this.ddd,
  );

  @override
  List<Object?> get props => [cep, logradouro, complemento, bairro, localidade, uf, ibge, ddd];
}
