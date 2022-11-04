part of 'promocoes_provider.dart';

final promocoesStreamProvider =
    StreamProvider((ref) => ref.watch(promoServiceProvider).stream);
