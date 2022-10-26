import 'package:elas_promocoes/promocao.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class PromocaoCard extends StatelessWidget {
  const PromocaoCard({super.key, required this.promocao});
  final Promocao promocao;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 250,
      child: Card(
        child: Column(
          children: [
            Image.network(
              promocao.imagemUrl,
              height: 100,
              fit: BoxFit.cover,
            ),
            Text(
              promocao.nome,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextButton(
                onPressed: () => Share.share(
                    '${promocao.nome} por apenas ${promocao.valor}. Confira: ${promocao.url}'),
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
