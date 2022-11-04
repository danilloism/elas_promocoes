import 'dart:async';

import 'package:elas_promocoes/features/auth/model/auth_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier extends StateNotifier<AuthUserModel?> {
  late final StreamSubscription<User?> _sub;

  AuthNotifier(FirebaseAuth auth) : super(null) {
    _sub = auth.authStateChanges().listen((event) {
      if (event?.email != state?.email) {
        if (event?.email == null) {
          state = null;
          return;
        }
        final newState = AuthUserModel(email: event!.email!);
        state = newState;
      }
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
