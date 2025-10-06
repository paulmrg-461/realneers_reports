import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:realneers_reports/presentation/shared/widgets/inputs.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:realneers_reports/routes/route_paths.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        SnackBar(content: Text(context.tr('auth.login.success'))),
      );
      // Redirigir al Home cuando el login sea exitoso
      context.go(Routes.home);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        SnackBar(content: Text(e.message ?? context.tr('auth.login.error'))),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('auth.login.title'))),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              EmailInput(controller: emailCtrl),
              PasswordInput(controller: passCtrl),
              const SizedBox(height: 16),
              FilledButton.icon(
                icon: Icon(Icons.login_outlined),
                onPressed: loading ? null : _login,
                label: loading
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(),
                      )
                    : Text(context.tr('auth.login.button')),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.push('/register'),
                child: Text(context.tr('auth.login.create_account')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
