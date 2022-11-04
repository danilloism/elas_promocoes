part of 'providers.dart';

final _storageProvider = Provider((ref) => FirebaseStorage.instance);

final storageRefProvider = Provider((ref) =>
    ref.watch(_storageProvider).refFromURL('gs://elas-promocoes.appspot.com'));
