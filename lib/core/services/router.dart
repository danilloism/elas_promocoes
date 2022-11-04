import 'package:elas_promocoes/features/auth/ui/login_page.dart';
import 'package:elas_promocoes/features/promocoes/ui/promocao_page.dart';
import 'package:elas_promocoes/main.dart';
import 'package:fluro/fluro.dart';

class RouterService {
  final FluroRouter router;
  RouterService(this.router) {
    router.define('/', handler: _homeHandler);
    router.define('/login', handler: _loginHandler);
    router.define('/:id', handler: _promocaoPageHandler);
  }
  Handler get _homeHandler =>
      Handler(handlerFunc: (_, __) => const MyHomePage());
  Handler get _loginHandler =>
      Handler(handlerFunc: (_, __) => const LoginPage());
  Handler get _promocaoPageHandler => Handler(handlerFunc: (context, params) {
        final id = params['id']![0];
        return PromocaoPage(promocaoId: id);
      });
}
