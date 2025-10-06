import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:realneers_reports/core/utils/validators.dart';
import 'app_text_input.dart';

class NameInput extends StatelessWidget {
  final TextEditingController controller;
  const NameInput({super.key, required this.controller});
  @override
  Widget build(BuildContext context) => AppTextInput(
        label: 'Nombre',
        hint: 'Tu nombre completo',
        controller: controller,
        validator: validateName,
        keyboardType: TextInputType.name,
      );
}

class EmailInput extends StatelessWidget {
  final TextEditingController controller;
  const EmailInput({super.key, required this.controller});
  @override
  Widget build(BuildContext context) => AppTextInput(
        label: 'Correo',
        hint: 'usuario@ejemplo.com',
        controller: controller,
        validator: validateEmail,
        keyboardType: TextInputType.emailAddress,
      );
}

class DniInput extends StatelessWidget {
  final TextEditingController controller;
  const DniInput({super.key, required this.controller});
  @override
  Widget build(BuildContext context) => AppTextInput(
        label: 'DNI',
        hint: 'Solo números',
        controller: controller,
        validator: (v) => validateDni(v, allowLetters: false),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      );
}

class PhoneInput extends StatelessWidget {
  final TextEditingController controller;
  const PhoneInput({super.key, required this.controller});
  @override
  Widget build(BuildContext context) => AppTextInput(
        label: 'Teléfono',
        hint: 'Ej: +51987654321',
        controller: controller,
        validator: validatePhone,
        keyboardType: TextInputType.phone,
      );
}

class PasswordInput extends StatelessWidget {
  final TextEditingController controller;
  const PasswordInput({super.key, required this.controller});
  @override
  Widget build(BuildContext context) => AppTextInput(
        label: 'Contraseña',
        hint: 'Mínimo 6 caracteres',
        controller: controller,
        validator: (v) {
          final value = (v ?? '').trim();
          if (value.length < 6) return 'Debe tener al menos 6 caracteres';
          return null;
        },
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
      );
}