class AuthUserModel {
  final String email;
  final String? senha;

  const AuthUserModel({
    required this.email,
    this.senha,
  });
}
