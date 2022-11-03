import 'package:elas_promocoes/providers/providers.dart';
import 'package:elas_promocoes/services/promocoes_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final promoServiceProvider = Provider((ref) {
  return PromocoesService(
      firestoreCollectionRef: ref.watch(promocoesCollectionProvider),
      storageRef: ref.watch(storageRefProvider));
});

final promocoesStreamProvider =
    StreamProvider((ref) => ref.watch(promoServiceProvider).stream);
