import 'package:elas_promocoes/generated/assets.dart';
import 'package:elas_promocoes/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _key = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _senhaController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _senhaController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Form(
          key: _key,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Assets.logo,
                  height: MediaQuery.of(context).size.height / 4,
                ),
                TextFormField(
                  validator: _emptyValidator,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFormField(
                  validator: _emptyValidator,
                  controller: _senhaController,
                  obscureText: true,
                ),
                const SizedBox(height: 8),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () {
                          if (_key.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });

                            final email = _emailController.text;
                            final senha = _senhaController.text;
                            ref
                                .read(authStateNotifierProvider.notifier)
                                .logar(email: email, senha: senha)
                                .whenComplete(() {
                              if (mounted) {
                                Navigator.of(context).pop();
                              }
                            });
                          }
                        },
                        child: const Text('Entrar'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _emptyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório.';
    }
    return null;
  }
}
