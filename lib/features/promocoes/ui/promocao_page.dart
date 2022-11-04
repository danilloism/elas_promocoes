import 'package:elas_promocoes/features/promocoes/model/promocao_model.dart';
import 'package:elas_promocoes/features/promocoes/provider/promocoes_provider.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class PromocaoPage extends ConsumerWidget {
  late final FutureProvider<PromocaoModel> promocaoProvider;
  PromocaoPage({super.key, required String promocaoId}) {
    promocaoProvider = FutureProvider((ref) async {
      final loadedList = ref.read(promocoesStreamProvider).valueOrNull;
      if (loadedList != null) {
        return loadedList.singleWhere((element) => element.id == promocaoId);
      }

      final snapshot =
          await ref.watch(promocoesCollectionProvider).doc(promocaoId).get();
      if (!snapshot.exists) {
        throw RouteNotFoundException('', '');
      }
      return PromocaoModel.fromJson(data: snapshot.data()!, id: snapshot.id);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(promocaoProvider);
    return asyncData.when(
      data: (promocao) => Scaffold(
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
      ),
      error: (error, stackTrace) => _error,
      loading: () => _loading,
    );
  }

  Widget get _error => const Scaffold(body: Text('Erro!'));
  Widget get _loading => Scaffold(
          body: Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          Text('Carregando...'),
        ],
      )));
}
