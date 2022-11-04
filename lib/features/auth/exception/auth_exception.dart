part 'auth_exception_type.dart';

class AuthException implements Exception {
  late final String mensagem;

  AuthException(AuthExceptionType tipo) {
    mensagem = tipo.mensagem;
  }
}
