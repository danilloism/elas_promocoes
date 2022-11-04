part of 'auth_provider.dart';

final authServiceProvider = Provider<IAuthService>(
    (ref) => FirebaseAuthService(ref.watch(_firebaseAuthProvider)));
