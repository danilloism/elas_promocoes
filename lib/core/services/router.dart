import 'package:elas_promocoes/features/auth/provider/auth_provider.dart';
import 'package:elas_promocoes/features/auth/ui/login_page.dart';
import 'package:elas_promocoes/features/promocoes/ui/editor_promocao.dart';
import 'package:elas_promocoes/features/promocoes/ui/promocao_page.dart';
import 'package:elas_promocoes/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RouterService {
  late final router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: !kReleaseMode,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MyHomePage(),
        routes: [
          GoRoute(
            path: 'view/:id',
            builder: (context, state) =>
                PromocaoPage(promocaoId: state.params['id']!),
          ),
          GoRoute(
            path: 'login',
            builder: (context, state) => const LoginPage(),
            redirect: (context, state) {
              final user = ref.watch(authStateProvider);
              if (user != null) {
                return '/';
              }

              return null;
            },
          ),
          GoRoute(
            path: 'adicionar',
            builder: (context, state) =>
                _guardedPage(EditorPromocao.adicionar()),
            redirect: _guardedRedirect,
          ),
          GoRoute(
            path: 'editar/:id',
            builder: (context, state) => _guardedPage(
                EditorPromocao.editar(promocaoId: state.params['id']!)),
            redirect: _guardedRedirect,
          ),
        ],
      ),
    ],
  );

  Widget _guardedPage(Widget page) {
    final user = ref.watch(authStateProvider);
    if (user == null) {
      return const MyHomePage();
    }
    return page;
  }

  String? _guardedRedirect(BuildContext context, GoRouterState state) {
    final user = ref.watch(authStateProvider);
    if (user == null) {
      return '/';
    }

    return null;
  }

  RouterService(this.ref);
  final Ref ref;
}
