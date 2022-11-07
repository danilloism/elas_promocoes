import 'package:elas_promocoes/features/auth/provider/auth_provider.dart';
import 'package:elas_promocoes/features/promocoes/model/promocao_model.dart';
import 'package:elas_promocoes/features/promocoes/provider/promocoes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class PromocaoCard extends ConsumerWidget {
  final PromocaoModel promocao;
  const PromocaoCard.vertical(this.promocao, {super.key}) : _isVertical = true;
  const PromocaoCard.horizontal(this.promocao, {super.key})
      : _isVertical = false;
  final bool _isVertical;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DecoratedBox(
      key: key,
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        border: Border.all(
          color: Colors.amberAccent[100]!,
        ),
      ),
      child: InkWell(
          onTap: () => context.push('/view/${promocao.id}'),
          child: _isVertical
              ? _VerticalCard(promocao, key: key)
              : _HorizontalCard(promocao, key: key)),
    );
  }
}

class _HorizontalCard extends StatelessWidget {
  const _HorizontalCard(this.promocao, {super.key});
  final PromocaoModel promocao;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      key: key,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              image: DecorationImage(
                image: NetworkImage(promocao.imagemUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        promocao.nome,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 3,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Consumer(builder: (context, ref, _) {
                    final logado = ref.watch(authStateProvider) != null;
                    if (logado) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: PopupMenuButton(
                          // icon: const Icon(Icons.more_horiz_outlined),
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
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                        "Confirmar exclusão do item ${promocao.nome}?"),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text("Cancelar")),
                                      TextButton(
                                          onPressed: () => ref
                                              .read(promoServiceProvider)
                                              .remove(promocao.id!)
                                              .whenComplete(() =>
                                                  Navigator.of(context).pop()),
                                          child: const Text("Confirmar")),
                                    ],
                                  ),
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
                        ),
                      );
                    }
                    return IconButton(
                        onPressed: () => Share.share(
                            '${promocao.nome} por apenas ${promocao.valor}. Confira: https://elas-promocoes.web.app/view/${promocao.id}'),
                        icon: const Icon(Icons.share));
                  }),
                ],
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      promocao.valor,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 18,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final uri = Uri.parse(promocao.url);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        }
                      },
                      child: const Text(
                        'Comprar\nagora!',
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VerticalCard extends StatelessWidget {
  const _VerticalCard(this.promocao, {super.key});
  final PromocaoModel promocao;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: key,
      width: 170,
      height: 310,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (promocao.imagemUrl.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  image: DecorationImage(
                    image: NetworkImage(promocao.imagemUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Text(
              promocao.nome,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
          // const Expanded(child: SizedBox()),
          Text(
            promocao.valor,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
              fontSize: 18,
            ),
          ),
          const Expanded(child: SizedBox()),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final uri = Uri.parse(promocao.url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Comprar agora!',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextButton(
              onPressed: () => Share.share(
                  '${promocao.nome} por apenas ${promocao.valor}. Confira: https://elas-promocoes.web.app/view/${promocao.id}'),
              child: const Text(
                'Compartilhar',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
