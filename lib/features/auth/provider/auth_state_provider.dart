part of 'auth_provider.dart';

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthUserModel?>(
        (ref) => AuthNotifier(ref.watch(_firebaseAuthProvider)));
