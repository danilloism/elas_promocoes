import 'package:elas_promocoes/features/auth/ui/login_page.dart';
import 'package:elas_promocoes/features/promocoes/model/promocao_model.dart';
import 'package:elas_promocoes/features/promocoes/ui/editor_promocao.dart';
import 'package:elas_promocoes/features/promocoes/ui/promocao_page.dart';
import 'package:elas_promocoes/main.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

class RouterService {
  final router = GoRouter(
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
                PromocaoPage(promocao: state.extra as PromocaoModel),
          ),
          GoRoute(
            path: 'login',
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
            path: 'adicionar',
            builder: (context, state) => const EditorPromocao(),
          ),
          GoRoute(
            path: 'editar/:id',
            builder: (context, state) => EditorPromocao(promocao: state.extra as PromocaoModel),
          ),
        ],
      ),
      // GoRoute(
      //   path: '/login',
      //   builder: (context, state) => const LoginPage(),
      // ),
    ],
  );

  RouterService();
}
