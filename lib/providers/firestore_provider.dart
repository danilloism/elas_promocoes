import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elas_promocoes/promocao.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _firestoreProvider = Provider((ref) => FirebaseFirestore.instance);
final promocoesCollectionProvider =
    Provider((ref) => ref.watch(_firestoreProvider).collection('promocoes'));
final promocoesStreamProvider = StreamProvider((ref) {
  final collection = ref.watch(promocoesCollectionProvider);
  final snapshots = collection.snapshots();
  return snapshots.map(
    (event) => event.docs
        .map((document) =>
            Promocao.fromJson(data: document.data(), id: document.id))
        .toList()
      ..sort((a, b) => b.criadoEm!.compareTo(a.criadoEm!)),
  );
});
