import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawerLoggedInSection extends StatelessWidget {
  const AppDrawerLoggedInSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            context.push('/adicionar');
            Scaffold.of(context).closeDrawer();
          },
          child: Row(
            children: const [
              Icon(Icons.person),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Adicionar Promoção',
                  maxLines: 2,
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () async {
            final uri = Uri.parse(
                'https://wa.me/+5562995305195/?text=${Uri.encodeComponent('Olá, Danillo. Queria falar com você sobre o Elas Promoções.')}');

            if (await canLaunchUrl(uri)) {
              await launchUrl(uri)
                  .whenComplete(() => Scaffold.of(context).closeDrawer());
            }
          },
          child: Row(
            children: const [
              Icon(Icons.logo_dev),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Contatar Desenvolvedor',
                  maxLines: 2,
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
