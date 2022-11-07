import 'package:elas_promocoes/core/ui/app_drawer_logged_in_section.dart';
import 'package:elas_promocoes/features/auth/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logado = ref.watch(authStateProvider) != null;
    return Drawer(
      width: MediaQuery.of(context).size.width / 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Scaffold.of(context).closeDrawer();
                    },
                    icon: const Icon(Icons.close))
              ],
            ),
            const SizedBox(height: 20),
            logado
                ? const AppDrawerLoggedInSection()
                : TextButton(
                    onPressed: () {
                      Scaffold.of(context).closeDrawer();
                      context.push('/login');
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.person),
                        SizedBox(width: 8),
                        Text('Login'),
                      ],
                    ),
                  ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.push('/login'),
              child: Row(
                children: const [
                  Icon(Icons.question_mark),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Quem somos nós?',
                      maxLines: 2,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.push('/login'),
              child: Row(
                children: const [
                  Icon(Icons.contact_page),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Entrar em contato',
                      maxLines: 2,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
            if (logado)
              TextButton(
                onPressed: () {
                  ref
                      .read(authServiceProvider)
                      .deslogar()
                      .whenComplete(() => Scaffold.of(context).closeDrawer());
                },
                child: Row(
                  children: const [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Sair'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
