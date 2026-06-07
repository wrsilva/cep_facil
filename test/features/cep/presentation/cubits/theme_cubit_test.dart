import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cep_facil/core/theme/theme_cubit.dart';

void main() {
  group('ThemeCubit', () {
    test('estado inicial deve ser ThemeMode.system', () {
      final cubit = ThemeCubit();
      expect(cubit.state, ThemeMode.system);
      cubit.close();
    });

    blocTest<ThemeCubit, ThemeMode>(
      'deve emitir ThemeMode.dark quando toggleTheme é chamado a partir do estado system',
      build: ThemeCubit.new,
      act: (cubit) => cubit.toggleTheme(),
      expect: () => [ThemeMode.dark],
    );

    blocTest<ThemeCubit, ThemeMode>(
      'deve emitir ThemeMode.light quando toggleTheme é chamado a partir do estado dark',
      build: ThemeCubit.new,
      seed: () => ThemeMode.dark,
      act: (cubit) => cubit.toggleTheme(),
      expect: () => [ThemeMode.light],
    );

    blocTest<ThemeCubit, ThemeMode>(
      'deve emitir ThemeMode.dark quando toggleTheme é chamado a partir do estado light',
      build: ThemeCubit.new,
      seed: () => ThemeMode.light,
      act: (cubit) => cubit.toggleTheme(),
      expect: () => [ThemeMode.dark],
    );
  });
}
