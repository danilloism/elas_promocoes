import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: 'lib/env/.env')
abstract class Env {
  @EnviedField(varName: 'SUPABASE_API_URL', obfuscate: true)
  static final supabaseApiUrl = _Env.supabaseApiUrl;

  @EnviedField(varName: 'SUPABASE_ANON_KEY', obfuscate: true)
  static final supabaseAnonKey = _Env.supabaseAnonKey;
}
