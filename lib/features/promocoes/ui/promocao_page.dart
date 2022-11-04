import 'package:elas_promocoes/features/promocoes/model/promocao_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class PromocaoPage extends ConsumerWidget {
  final PromocaoModel promocao;
  const PromocaoPage({super.key, required this.promocao});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: [
            Image.network(promocao.imagemUrl),
            Text(
              promocao.nome,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (promocao.descricao != null)
              Text(
                promocao.descricao!,
                textAlign: TextAlign.justify,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextButton(
                onPressed: () => Share.share(
                    '${promocao.nome} por apenas ${promocao.valor}. Confira: https://elas-promocoes.web.app/${promocao.id}'),
                child: const Text(
                  'Compartilhar',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
