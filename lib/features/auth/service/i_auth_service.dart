abstract class IAuthService {
  Future<void> logar({required String email, required String senha});
  Future<void> deslogar();
  Future<void> registrar({required String email, required String senha});
}
