part of 'promocoes_provider.dart';

final promocoesCollectionProvider =
    Provider((ref) => ref.watch(firestoreProvider).collection('promocoes'));
