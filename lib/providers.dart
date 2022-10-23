import 'package:elas_promocoes/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);
final authStateProvider = StateNotifierProvider<AuthStateNotifier, User?>(
    (ref) => AuthStateNotifier(ref.watch(firebaseAuthProvider)));
