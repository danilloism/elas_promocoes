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
        width: 150,
        height: 270,
        child: Card(
          child: Column(
            children: [
              if (promocao.imagemUrl.isNotEmpty)
                Image.network(
                  promocao.imagemUrl,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  promocao.nome,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                promocao.valor,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final uri = Uri.parse(promocao.url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  },
                  child: const Text(
                    'Comprar agora!',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
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
