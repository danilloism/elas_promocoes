// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';

class Logger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    print('''
update {
  "provider": "${provider.name ?? provider.runtimeType}",
  "newValue": "$newValue"
}''');
    super.didUpdateProvider(provider, previousValue, newValue, container);
  }

  @override
  void didDisposeProvider(ProviderBase provider, ProviderContainer container) {
    print('''
dispose {
  "provider": "${provider.name ?? provider.runtimeType}",
}''');
    super.didDisposeProvider(provider, container);
  }

  @override
  void didAddProvider(
      ProviderBase provider, Object? value, ProviderContainer container) {
    print('''
add {
  "provider": "${provider.name ?? provider.runtimeType}",
  "value": "$value"
}''');
    super.didAddProvider(provider, value, container);
  }
}
