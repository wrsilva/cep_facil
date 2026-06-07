import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:cep_facil/features/cep/domain/entities/cep_entity.dart';

class CepRoute {
  CepRoute._();

  static const search = '/search';
  static const result = '/result';

  static void goSearch(BuildContext context) => context.go(search);

  static void pushResult(BuildContext context, CepEntity entity) => context.push(result, extra: entity);
}
