part of 'providers.dart';

final _fluroRouterProvider = Provider((ref) => FluroRouter());

final routerServiceProvider =
    Provider((ref) => RouterService(ref.watch(_fluroRouterProvider)));
