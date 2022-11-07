// ignore: avoid_web_libraries_in_flutter
import 'dart:html' show window;

import 'package:elas_promocoes/core/const.dart';
import 'package:elas_promocoes/core/extensions/ui_extensions.dart';
import 'package:elas_promocoes/core/providers/providers.dart';
import 'package:elas_promocoes/core/services/logger.dart';
import 'package:elas_promocoes/core/ui/app_drawer.dart';
import 'package:elas_promocoes/features/auth/provider/auth_provider.dart';
import 'package:elas_promocoes/features/promocoes/ui/lista_promocoes.dart';
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

  runApp(
    ProviderScope(
      observers: kReleaseMode ? null : [Logger()],
      child: const MyApp(),
    ),
  );
  urlConfig();
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
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
    return LayoutBuilder(builder: (context, contraints) {
      return Scaffold(
        drawer: contraints.isMobile ? const AppDrawer() : null,
        persistentFooterButtons: const [
          Text('Copyright © 2022 Danillo Ilggner',
              style: TextStyle(fontSize: 10)),
        ],
        persistentFooterAlignment: AlignmentDirectional.center,
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Image.asset(
                  Assets.logo,
                  height: 50,
                ),
              ),
              const SizedBox(width: 8),
              Text('Elas\nPromoções',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    height: 1,
                  )),
            ],
          ),
          actions: logado
              ? [
                  IconButton(
                    onPressed: () => ref.read(authServiceProvider).deslogar(),
                    icon: const Icon(Icons.logout),
                  )
                ]
              : null,
        ),
        floatingActionButton: logado && contraints.isMobile
            ? FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () => context.push('/adicionar'),
              )
            : null,
        body: const Padding(
          padding: EdgeInsets.all(8.0),
          child: ListaPromocoes(),
        ),
      );
    });
  }
}
