part of 'auth_exception.dart';

enum AuthExceptionType {
  senhaFraca('Senha fraca.'),
  emailEmUso('Email já está em uso.'),
  emailInvalido('Email inválido.'),
  usuarioNaoEncontrado('Usuário não encontrado.'),
  usuarioDesabilitado('Usuário com conta desabilitada.'),
  senhaIncorreta('E-mail ou senha incorretos.'),
  erroDesconhecido('Erro desconhecido');

  final String mensagem;

  const AuthExceptionType(this.mensagem);
}
