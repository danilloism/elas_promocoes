import 'package:elas_promocoes/features/promocoes/provider/promocoes_provider.dart';
import 'package:elas_promocoes/features/promocoes/ui/promocao_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListaPromocoes extends ConsumerWidget {
  const ListaPromocoes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final promocoesAsyncValue = ref.watch(promocoesStreamProvider);
        return promocoesAsyncValue.when(
          data: (promocoes) {
            if (constraints.maxWidth > 480) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: constraints.maxHeight / 2,
                  mainAxisExtent: 310,
                ),
                itemCount: promocoes.length,
                itemBuilder: (context, index) {
                  final promocao = promocoes[index];
                  return PromocaoCard.vertical(
                    promocao,
                    key: ValueKey(promocao.id!),
                  );
                },
              );
            }

            return ListView.separated(
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemCount: promocoes.length,
              itemBuilder: (context, index) {
                final promocao = promocoes[index];
                return PromocaoCard(
                  promocao: promocao,
                  isVertical: false,
                  key: ValueKey(promocao.id!),
                );
              },
            );
          },
          error: (_, __) => const Text('Erro'),
          loading: () => Column(
            children: const [
              CircularProgressIndicator(),
              Text('Carregando...'),
            ],
          ),
        );
      },
    );
  }
}
