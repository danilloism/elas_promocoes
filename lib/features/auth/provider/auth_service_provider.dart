part of 'auth_provider.dart';

final authServiceProvider = Provider.autoDispose<IAuthService>(
    (ref) => FirebaseAuthService(ref.watch(_firebaseAuthProvider)));
