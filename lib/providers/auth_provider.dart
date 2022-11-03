import 'package:elas_promocoes/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);

final authStateProvider = StateNotifierProvider<AuthStateNotifier, User?>(
    (ref) => AuthStateNotifier(ref.watch(_firebaseAuthProvider)));
