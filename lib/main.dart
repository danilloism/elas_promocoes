import 'dart:html';

import 'package:elas_promocoes/firebase_options.dart';
import 'package:elas_promocoes/generated/assets.dart';
import 'package:elas_promocoes/providers/providers.dart';
import 'package:elas_promocoes/services/logger.dart';
import 'package:elas_promocoes/ui/editor_promocao.dart';
import 'package:elas_promocoes/ui/login_page.dart';
import 'package:elas_promocoes/ui/promocao_card.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ProviderScope(
    observers: kReleaseMode ? null : [Logger()],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elas Promoções',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
        fontFamily: kIsWeb && window.navigator.userAgent.contains('OS 15_')
            ? '-apple-system'
            : null,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logado = ref.watch(authStateNotifierProvider) != null;
    ref.listen(authStateNotifierProvider, (previous, next) {});
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 120,
        title: Image.asset(
          Assets.logo,
          fit: BoxFit.contain,
          height: 120,
          isAntiAlias: true,
        ),
        leading: logado
            ? Builder(builder: (context) {
                return IconButton(
                    onPressed: () => showDialog(
                          context: context,
                          builder: (context) => const EditorPromocao(),
                        ),
                    icon: const Icon(Icons.add));
              })
            : null,
        actions: logado
            ? [
                IconButton(
                  onPressed: () =>
                      ref.read(authStateNotifierProvider.notifier).deslogar(),
                  icon: const Icon(Icons.logout),
                )
              ]
            : null,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  children: ref.watch(promocoesStreamProvider).when(
                        data: (data) => data.map((e) {
                          if (ref.watch(authStateNotifierProvider) == null) {
                            return PromocaoCard(
                                promocao: e, key: ValueKey(e.id));
                          }

                          return Card(
                            key: ValueKey(e.id),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextButton(
                                        onPressed: () {},
                                        child: const Text('Editar')),
                                    const SizedBox(width: 12),
                                    IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text(
                                                  "Confirmar exclusão do item ${e.nome}?"),
                                              actions: [
                                                ElevatedButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                    child:
                                                        const Text("Cancelar")),
                                                TextButton(
                                                    onPressed: () => ref
                                                        .read(
                                                            promoServiceProvider)
                                                        .remove(e.id!)
                                                        .whenComplete(() =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop()),
                                                    child: const Text(
                                                        "Confirmar")),
                                              ],
                                            ),
                                          );
                                        },
                                        icon: const Icon(CupertinoIcons.trash)),
                                  ],
                                ),
                                PromocaoCard(promocao: e),
                              ],
                            ),
                          );
                        }).toList(),
                        error: (_, __) => const [Text('Erro')],
                        loading: () => const [
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      ),
                ),
              ),
            ),
          ),
          if (!logado)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const LoginPage()));
                    },
                    child: const Text('Administrador')),
              ],
            ),
        ],
      ),
    );
  }
}
