import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:realneers_reports/presentation/shared/widgets/inputs.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:realneers_reports/features/auth/data/user_profile_service.dart';

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
      final messenger = ScaffoldMessenger.of(context);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Login exitoso')),
      );
    } on FirebaseAuthException catch (e) {
      final messenger = ScaffoldMessenger.of(context);
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(e.message ?? 'Error de autenticación')),
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
      appBar: AppBar(title: const Text('Login')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              EmailInput(controller: emailCtrl),
              const SizedBox(height: 12),
              PasswordInput(controller: passCtrl),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loading ? null : _login,
                child: loading
                    ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator())
                    : const Text('Ingresar'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.push('/register'),
                child: const Text('Crear cuenta'),
              )
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
      // Guardar perfil en Firestore
      final uid = cred.user?.uid;
      if (uid != null) {
        final service = UserProfileService(firestore: FirebaseFirestore.instance);
        await service.saveUserProfile(
          uid: uid,
          name: nameCtrl.text,
          email: emailCtrl.text,
          dni: dniCtrl.text,
          phone: phoneCtrl.text,
        );
      }
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Registro exitoso')),
      );
      navigator.pop();
    } on FirebaseAuthException catch (e) {
      final messenger = ScaffoldMessenger.of(context);
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(e.message ?? 'Error en registro')),
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
      appBar: AppBar(title: const Text('Registro')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                NameInput(controller: nameCtrl),
                const SizedBox(height: 12),
                EmailInput(controller: emailCtrl),
                const SizedBox(height: 12),
                DniInput(controller: dniCtrl),
                const SizedBox(height: 12),
                PhoneInput(controller: phoneCtrl),
                const SizedBox(height: 12),
                PasswordInput(controller: passCtrl),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: loading ? null : _register,
                  child: loading
                      ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator())
                      : const Text('Registrarme'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}