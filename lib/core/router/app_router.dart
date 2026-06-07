import 'package:go_router/go_router.dart';
import 'package:cep_facil/features/cep/cep_route.dart';
import 'package:cep_facil/features/cep/domain/entities/cep_entity.dart';
import 'package:cep_facil/features/cep/presentation/pages/cep_result_page.dart';
import 'package:cep_facil/features/cep/presentation/pages/cep_search_page.dart';
import 'package:cep_facil/features/splash/presentation/pages/splash_page.dart';
import 'package:cep_facil/features/splash/splash_route.dart';

final appRouter = GoRouter(
  initialLocation: SplashRoute.path,
  routes: [
    GoRoute(
      path: SplashRoute.path,
      builder: (ctx, st) => const SplashPage(),
    ),
    GoRoute(
      path: CepRoute.search,
      builder: (ctx, st) => const CepSearchPage(),
    ),
    GoRoute(
      path: CepRoute.result,
      builder: (context, state) {
        final entity = state.extra! as CepEntity;
        return CepResultPage(entity: entity);
      },
    ),
  ],
);
