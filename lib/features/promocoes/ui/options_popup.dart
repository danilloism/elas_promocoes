import 'package:elas_promocoes/core/ui/loading.dart';
import 'package:elas_promocoes/features/promocoes/model/promocao_model.dart';
import 'package:elas_promocoes/features/promocoes/provider/promocoes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

class OptionsPopup extends ConsumerWidget {
  const OptionsPopup(this.promocao, {super.key, this.icon});
  final PromocaoModel promocao;
  final Icon? icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton(
      icon: icon,
      onSelected: (value) {
        switch (value) {
          case 0:
            Share.share(
                '${promocao.nome} por apenas ${promocao.valor}. Confira: https://elas-promocoes.web.app/view/${promocao.id}');
            break;
          case 1:
            context.push('/editar/${promocao.id}');
            break;
          case 2:
            showDialog(
              context: context,
              builder: (context) {
                bool isLoading = false;
                return StatefulBuilder(builder: (context, setState) {
                  return AlertDialog(
                    title: Text("Confirmar exclusão do item ${promocao.nome}?"),
                    actions: isLoading
                        ? const [Loading()]
                        : [
                            ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("Cancelar")),
                            TextButton(
                                onPressed: () {
                                  setState(() => isLoading = true);
                                  ref
                                      .read(promoServiceProvider)
                                      .remove(promocao.id!)
                                      .whenComplete(
                                          () => Navigator.of(context).pop());
                                },
                                child: const Text("Confirmar")),
                          ],
                  );
                });
              },
            );
            break;
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: 0,
            child: Text('Compartilhar'),
          ),
          const PopupMenuItem(
            value: 1,
            child: Text('Editar'),
          ),
          const PopupMenuItem(
            value: 2,
            child: Text('Excluir'),
          ),
        ];
      },
    );
  }
}
