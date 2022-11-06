// ignore: avoid_web_libraries_in_flutter
import 'dart:html' show window;

import 'package:device_preview/device_preview.dart';
import 'package:elas_promocoes/core/providers/providers.dart';
import 'package:elas_promocoes/core/services/logger.dart';
import 'package:elas_promocoes/features/auth/provider/auth_provider.dart';
import 'package:elas_promocoes/features/promocoes/provider/promocoes_provider.dart';
import 'package:elas_promocoes/features/promocoes/ui/promocao_card.dart';
import 'package:elas_promocoes/firebase_options.dart';
import 'package:elas_promocoes/generated/assets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import './url_strategy_native_config.dart'
    if (dart.library.html) './url_strategy_web_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => ProviderScope(
      observers: kReleaseMode ? null : [Logger()],
      child: const MyApp(),
    ),
  ));
  urlConfig();
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Elas Promoções',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // useMaterial3: true,
        fontFamily: kIsWeb && window.navigator.userAgent.contains('OS 15_')
            ? '-apple-system'
            : null,
      ),
      routerConfig:
          ref.watch(routerServiceProvider.select((service) => service.router)),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logado = ref.watch(authStateProvider) != null;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // title: Image.asset(
        //   Assets.logo,
        //   fit: BoxFit.cover,
        //   height: 80,
        //   width: 80,
        //   isAntiAlias: true,
        // ),
        title: Text('Elas\nPromoções',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              height: 1,
            )),
        leading: logado
            ? IconButton(
                onPressed: () => context.push('/adicionar'),
                icon: const Icon(Icons.add))
            : null,
        actions: logado
            ? [
                IconButton(
                  onPressed: () => ref.read(authServiceProvider).deslogar(),
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
                          if (ref.watch(authStateProvider) == null) {
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
                                        onPressed: () => context
                                            .push('/editar/${e.id}', extra: e),
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
                      context.push('/login');
                    },
                    child: const Text('Administrador')),
              ],
            ),
        ],
      ),
    );
  }
}
