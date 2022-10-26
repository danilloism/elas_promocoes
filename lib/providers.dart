import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elas_promocoes/auth.dart';
import 'package:elas_promocoes/promocao.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);
final authStateProvider = StateNotifierProvider<AuthStateNotifier, User?>(
    (ref) => AuthStateNotifier(ref.watch(firebaseAuthProvider)));
final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);
final promocoesStreamProvider = StreamProvider((ref) {
  final db = ref.watch(firestoreProvider);
  final snapshots = db.collection('promocoes').snapshots();
  return snapshots.map(
    (event) => event.docs
        .map((document) =>
            Promocao.fromJson(data: document.data(), id: document.id))
        .toList()
      ..sort((a, b) => b.criadoEm!.compareTo(a.criadoEm!)),
  );
});
