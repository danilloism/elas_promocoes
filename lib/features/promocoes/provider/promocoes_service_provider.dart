part of 'promocoes_provider.dart';

final promoServiceProvider = Provider((ref) {
  return PromocoesService(
      firestoreCollectionRef: ref.watch(promocoesCollectionProvider),
      storageRef: ref.watch(storageRefProvider));
});
