import 'package:elas_promocoes/features/promocoes/model/promocao_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class PromocaoCard extends ConsumerWidget {
  const PromocaoCard({super.key, required this.promocao});
  final PromocaoModel promocao;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => context.push('/view/${promocao.id}'),
      child: SizedBox(
        width: 170,
        height: 300,
        child: Card(
          child: Column(
            children: [
              if (promocao.imagemUrl.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Text(
                  promocao.nome,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Expanded(child: SizedBox()),
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
        ),
      ),
    );
  }
}
