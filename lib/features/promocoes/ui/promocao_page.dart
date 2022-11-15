import 'package:elas_promocoes/core/extensions/ui_extensions.dart';
import 'package:elas_promocoes/core/ui/loading.dart';
import 'package:elas_promocoes/features/promocoes/provider/promocoes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class PromocaoPage extends ConsumerWidget {
  final AutoDisposeFutureProvider promocaoProvider;
  PromocaoPage({super.key, required String promocaoId})
      : promocaoProvider = singlePromocaoProvider(promocaoId);

  Widget Function(Object, StackTrace) get _error =>
      (_, __) => Scaffold(appBar: AppBar());
  Widget Function() get _loading => () => Scaffold(
        appBar: AppBar(title: const Text('Carregando promoção...')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            Loading(),
            SizedBox(height: 8),
            Text(
              'Aguarde um momento...',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(promocaoProvider);
    return asyncValue.when(
        error: _error,
        loading: _loading,
        data: (promocao) => Scaffold(
              persistentFooterAlignment: AlignmentDirectional.centerStart,
              persistentFooterButtons: [
                ElevatedButton(
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Share.share(
                      '${promocao.nome} por apenas ${promocao.valor}. Confira: https://elas-promocoes.web.app/${promocao.id}'),
                  child: const Text(
                    'Compartilhar',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              appBar: AppBar(backgroundColor: Colors.transparent),
              body: Padding(
                padding: const EdgeInsets.all(8),
                child: ListView(
                  children: [
                    LayoutBuilder(builder: (context, constraints) {
                      return Container(
                        height: /*constraints.isMobile ? 300 :*/ 300,
                        padding: constraints.isMobile
                            ? null
                            : EdgeInsets.symmetric(
                                horizontal: constraints.maxWidth / 3),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            image: DecorationImage(
                              image: NetworkImage(promocao.imagemUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        promocao.nome,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (promocao.descricao != null)
                      Text(
                        promocao.descricao!,
                        textAlign: TextAlign.justify,
                      ),
                  ],
                ),
              ),
            ));
  }
}
