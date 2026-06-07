import 'package:flutter/material.dart';
import 'package:cep_facil/app.dart';
import 'package:cep_facil/core/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const App());
}
