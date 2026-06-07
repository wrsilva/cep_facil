import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:cep_facil/features/cep/domain/entities/cep_entity.dart';

@immutable
sealed class CepState extends Equatable {
  const CepState();
}

final class CepInitial extends CepState {
  const CepInitial();

  @override
  List<Object?> get props => [];
}

final class CepLoading extends CepState {
  const CepLoading();

  @override
  List<Object?> get props => [];
}

final class CepSuccess extends CepState {
  const CepSuccess(this.entity);

  final CepEntity entity;

  @override
  List<Object?> get props => [entity];
}

final class CepFailure extends CepState {
  const CepFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
