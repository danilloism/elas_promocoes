import 'package:elas_promocoes/core/const.dart';
import 'package:elas_promocoes/core/extensions/ui_extensions.dart';
import 'package:elas_promocoes/core/ui/loading.dart';
import 'package:elas_promocoes/features/promocoes/provider/promocoes_provider.dart';
import 'package:elas_promocoes/features/promocoes/ui/promocao_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ListaPromocoes extends ConsumerWidget {
  const ListaPromocoes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final promocoesAsyncValue = ref.watch(promocoesStreamProvider);
        return promocoesAsyncValue.when(
          data: (promocoes) {
            if (!constraints.isMobile) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: constraints.maxHeight / 1.5,
                  mainAxisExtent: 300,
                ),
                itemCount: promocoes.length,
                itemBuilder: (context, index) {
                  final promocao = promocoes[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PromocaoCard.vertical(
                      promocao,
                      key: ValueKey(promocao.id!),
                    ),
                  );
                },
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemCount: promocoes.length,
              itemBuilder: (context, index) {
                final promocao = promocoes[index];
                return PromocaoCard.horizontal(
                  promocao,
                  key: ValueKey(promocao.id!),
                );
              },
            );
          },
          error: (_, __) => const Text('Erro'),
          loading: () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Loading(),
              Text('Carregando...'),
            ],
          ),
        );
      },
    );
  }
}
