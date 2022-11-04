import 'package:elas_promocoes/features/auth/exception/auth_exception.dart';

class AuthExceptionTypeParser {
  const AuthExceptionTypeParser._();

  static AuthExceptionType fromFirebase(String errorCode) {
    switch (errorCode) {
      case 'weak-password':
        return AuthExceptionType.senhaFraca;
      case 'email-already-in-use':
        return AuthExceptionType.emailEmUso;
      case 'invalid-email':
        return AuthExceptionType.emailInvalido;
      case 'user-not-found':
        return AuthExceptionType.usuarioNaoEncontrado;
      case 'user-disabled':
        return AuthExceptionType.usuarioDesabilitado;
      case 'wrong-password':
        return AuthExceptionType.senhaIncorreta;
      default:
        return AuthExceptionType.erroDesconhecido;
    }
  }
}
