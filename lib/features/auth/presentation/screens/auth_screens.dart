import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:realneers_reports/presentation/shared/widgets/inputs.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:realneers_reports/features/auth/data/user_profile_service.dart';
import 'package:easy_localization/easy_localization.dart';

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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final dniCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);
    try {
      final messenger = ScaffoldMessenger.of(context);
      final navigator = Navigator.of(context);
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );
      await cred.user?.updateDisplayName(nameCtrl.text.trim());
      final uid = cred.user?.uid;
      if (uid != null) {
        try {
          final service = UserProfileService(
            firestore: FirebaseFirestore.instance,
          );
          await service.saveUserProfile(
            uid: uid,
            name: nameCtrl.text,
            email: emailCtrl.text,
            dni: dniCtrl.text,
            phone: phoneCtrl.text,
          );
        } catch (e) {
          if (!mounted) return;
          final messenger = ScaffoldMessenger.of(context);
          messenger.showSnackBar(
            SnackBar(
              content: Text(context.tr('auth.register.save_profile_error')),
            ),
          );
        }
      }
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(context.tr('auth.register.success'))),
      );
      navigator.pop();
    } on FirebaseAuthException catch (e) {
      final messenger = ScaffoldMessenger.of(context);
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(e.message ?? context.tr('auth.register.error'))),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    dniCtrl.dispose();
    phoneCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('auth.register.title'))),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                NameInput(controller: nameCtrl),
                EmailInput(controller: emailCtrl),
                DniInput(controller: dniCtrl),
                PhoneInput(controller: phoneCtrl),
                PasswordInput(controller: passCtrl),
                const SizedBox(height: 16),

                FilledButton.icon(
                  icon: Icon(Icons.account_circle_outlined),
                  onPressed: loading ? null : _register,
                  label: loading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(),
                        )
                      : Text(context.tr('auth.register.button')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
