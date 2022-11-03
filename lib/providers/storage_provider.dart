import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _storageProvider = Provider((ref) => FirebaseStorage.instance);

final storageRefProvider = Provider((ref) =>
    ref.watch(_storageProvider).refFromURL('gs://elas-promocoes.appspot.com'));
