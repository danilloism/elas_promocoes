part of 'promocoes_provider.dart';

final singlePromocaoProvider =
    FutureProvider.family.autoDispose<PromocaoModel, String>((ref, id) async {
  final loadedList = ref.read(promocoesStreamProvider).valueOrNull;
  if (loadedList != null) {
    return loadedList.singleWhere((element) => element.id == id);
  }

  final snapshot = await ref.watch(promocoesCollectionProvider).doc(id).get();
  if (!snapshot.exists) {
    throw Exception();
  }
  return PromocaoModel.fromJson(data: snapshot.data()!, id: snapshot.id);
});
