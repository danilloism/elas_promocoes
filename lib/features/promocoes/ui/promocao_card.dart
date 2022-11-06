import 'package:elas_promocoes/features/promocoes/model/promocao_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class PromocaoCard extends ConsumerWidget {
  const PromocaoCard(
      {super.key, required this.promocao, required bool isVertical})
      : _isVertical = isVertical;
  final PromocaoModel promocao;
  const PromocaoCard.vertical(this.promocao, {super.key}) : _isVertical = true;
  final bool _isVertical;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DecoratedBox(
      key: key,
      decoration: BoxDecoration(),
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
        Container(
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
        const SizedBox(width: 8),
        Flexible(
          child: Column(
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
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                  IconButton(
                      alignment: Alignment.topCenter,
                      onPressed: () {},
                      icon: const Icon(Icons.more_horiz_outlined)),
                ],
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
