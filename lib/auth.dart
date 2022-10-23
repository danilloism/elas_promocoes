import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum _AuthExceptionType {
  senhaFraca('Senha fraca.'),
  emailEmUso('Email já está em uso.'),
  emailInvalido('Email inválido.'),
  usuarioNaoEncontrado('Usuário não encontrado.'),
  usuarioDesabilitado('Usuário com conta desabilitada.'),
  senhaIncorreta('E-mail ou senha incorretos.');

  final String mensagem;

  const _AuthExceptionType(this.mensagem);
}

class AuthException implements Exception {
  late final String mensagem;

  AuthException(_AuthExceptionType tipo) {
    mensagem = tipo.mensagem;
  }
}

const _exceptionTypeMap = {
  'weak-password': _AuthExceptionType.senhaFraca,
  'email-already-in-use': _AuthExceptionType.emailEmUso,
  'invalid-email': _AuthExceptionType.emailInvalido,
  'user-not-found': _AuthExceptionType.usuarioNaoEncontrado,
  'user-disabled': _AuthExceptionType.usuarioDesabilitado,
  'wrong-password': _AuthExceptionType.senhaIncorreta,
};

class AuthStateNotifier extends StateNotifier<User?> {
  late final StreamSubscription<User?> _sub;
  final FirebaseAuth auth;

  AuthStateNotifier(this.auth) : super(auth.currentUser) {
    _sub = auth.authStateChanges().listen((event) => state = event);
  }

  bool _emailEhVerificado(User? user) {
    if (user == null) return false;
    return user.emailVerified;
  }

  Future<void> registrar({required String email, required String senha}) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: senha);

      final user = userCredential.user;
      if (_emailEhVerificado(user)) {
        await user?.sendEmailVerification();
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(_exceptionTypeMap[e.code]!);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logar({required String email, required String senha}) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: senha);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_exceptionTypeMap[e.code]!);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deslogar() async => await auth.signOut();

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
