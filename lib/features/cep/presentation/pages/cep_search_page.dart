import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cep_facil/core/di/injection.dart';
import 'package:cep_facil/core/theme/theme_cubit.dart';
import 'package:cep_facil/features/cep/cep_route.dart';
import 'package:cep_facil/features/cep/presentation/cubits/cep_cubit.dart';
import 'package:cep_facil/features/cep/presentation/cubits/cep_state.dart';
import 'package:cep_facil/features/cep/presentation/widgets/cep_text_field.dart';
import 'package:go_router/go_router.dart';

class CepSearchPage extends StatelessWidget {
  const CepSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => sl<CepCubit>(), child: const _CepSearchView());
  }
}

class _CepSearchView extends StatefulWidget {
  const _CepSearchView();

  @override
  State<_CepSearchView> createState() => _CepSearchViewState();
}

class _CepSearchViewState extends State<_CepSearchView> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<CepCubit>().searchCep(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CEP Fácil'),
        actions: [IconButton(icon: const Icon(Icons.brightness_6), onPressed: () => context.read<ThemeCubit>().toggleTheme(), tooltip: 'Alternar tema')],
      ),
      body: BlocConsumer<CepCubit, CepState>(
        listener: (context, state) {
          if (state is CepSuccess) {
            CepRoute.pushResult(context, state.entity);
          } else if (state is CepFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Theme.of(context).colorScheme.error));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  Text('Consulte um CEP', style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
                  const SizedBox(height: 32),
                  CepTextField(controller: _controller, onSubmitted: _search),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: state is CepLoading ? null : _search,
                    child: state is CepLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Buscar'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
