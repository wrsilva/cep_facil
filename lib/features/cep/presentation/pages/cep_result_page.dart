import 'package:flutter/material.dart';
import 'package:cep_facil/features/cep/cep_route.dart';
import 'package:cep_facil/features/cep/domain/entities/cep_entity.dart';
import 'package:cep_facil/features/cep/presentation/widgets/cep_result_card.dart';

class CepResultPage extends StatelessWidget {
  const CepResultPage({super.key, required this.entity});

  final CepEntity entity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado'),
        leading: BackButton(onPressed: () => CepRoute.goSearch(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.location_on, size: 40, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('CEP', style: Theme.of(context).textTheme.labelSmall),
                          Text(entity.cep, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            CepResultCard(label: 'Logradouro', value: entity.logradouro, icon: Icons.signpost_outlined),
            CepResultCard(label: 'Complemento', value: entity.complemento, icon: Icons.info_outline),
            CepResultCard(label: 'Bairro', value: entity.bairro, icon: Icons.map_outlined),
            CepResultCard(label: 'Cidade / Estado', value: '${entity.localidade} - ${entity.uf}', icon: Icons.location_city_outlined),
            CepResultCard(label: 'DDD', value: entity.ddd, icon: Icons.phone_outlined),
            CepResultCard(label: 'IBGE', value: entity.ibge, icon: Icons.numbers_outlined),
            const SizedBox(height: 24),
            ElevatedButton.icon(onPressed: () => CepRoute.goSearch(context), icon: const Icon(Icons.search), label: const Text('Nova busca')),
          ],
        ),
      ),
    );
  }
}
