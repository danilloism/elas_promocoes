import 'package:elas_promocoes/features/auth/exception/auth_exception.dart';
import 'package:elas_promocoes/features/auth/exception/auth_exception_type_parser.dart';
import 'package:elas_promocoes/features/auth/service/i_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService implements IAuthService {
  final FirebaseAuth instance;

  const FirebaseAuthService(this.instance);

  @override
  Future<void> deslogar() async => await instance.signOut();

  @override
  Future<void> logar({required String email, required String senha}) async {
    try {
      await instance.signInWithEmailAndPassword(email: email, password: senha);
    } on FirebaseAuthException catch (e) {
      throw AuthException(AuthExceptionTypeParser.fromFirebase(e.code));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> registrar({required String email, required String senha}) async {
    try {
      final userCredential = await instance.createUserWithEmailAndPassword(
          email: email, password: senha);

      final user = userCredential.user;
      if (_emailEhVerificado(user)) {
        await user?.sendEmailVerification();
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(AuthExceptionTypeParser.fromFirebase(e.code));
    } catch (e) {
      rethrow;
    }
  }

  bool _emailEhVerificado(User? user) {
    if (user == null) return false;
    return user.emailVerified;
  }
}
