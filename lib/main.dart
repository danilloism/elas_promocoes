import 'package:elas_promocoes/editor_promocao.dart';
import 'package:elas_promocoes/firebase_options.dart';
import 'package:elas_promocoes/generated/assets.dart';
import 'package:elas_promocoes/logger.dart';
import 'package:elas_promocoes/login_page.dart';
import 'package:elas_promocoes/providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ProviderScope(
    observers: [Logger()],
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
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logado = ref.watch(authStateProvider) != null;
    ref.listen(authStateProvider, (previous, next) {});
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
                      ref.read(authStateProvider.notifier).deslogar(),
                  icon: const Icon(Icons.logout),
                )
              ]
            : null,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Text('Texto'),
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
