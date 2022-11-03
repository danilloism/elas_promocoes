import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _firestoreProvider = Provider((ref) => FirebaseFirestore.instance);
final promocoesCollectionProvider =
    Provider((ref) => ref.watch(_firestoreProvider).collection('promocoes'));
