import 'package:flutter/material.dart';

import 'package:realneers_reports/core/utils/validators.dart';
import 'custom_input.dart';
import 'package:easy_localization/easy_localization.dart';

class NameInput extends StatelessWidget {
  final TextEditingController controller;
  const NameInput({super.key, required this.controller});
  @override
  Widget build(BuildContext context) => CustomInput(
    labelText: context.tr('input.name.label'),
    hintText: context.tr('input.name.hint'),
    controller: controller,
    validator: validateName,
    textInputType: TextInputType.name,
    icon: Icons.person_outline,
  );
}

class EmailInput extends StatelessWidget {
  final TextEditingController controller;
  const EmailInput({super.key, required this.controller});
  @override
  Widget build(BuildContext context) => CustomInput(
    labelText: context.tr('input.email.label'),
    hintText: context.tr('input.email.hint'),
    controller: controller,
    validator: validateEmail,
    textInputType: TextInputType.emailAddress,
    icon: Icons.email_outlined,
  );
}

class DniInput extends StatelessWidget {
  final TextEditingController controller;
  const DniInput({super.key, required this.controller});
  @override
  Widget build(BuildContext context) => CustomInput(
    labelText: context.tr('input.dni.label'),
    hintText: context.tr('input.dni.hint'),
    controller: controller,
    validator: (v) => validateDni(v, allowLetters: false),
    textInputType: TextInputType.number,
    isNumeric: true,
    icon: Icons.numbers_outlined,
  );
}

class PhoneInput extends StatelessWidget {
  final TextEditingController controller;
  const PhoneInput({super.key, required this.controller});
  @override
  Widget build(BuildContext context) => CustomInput(
    hintText: context.tr('input.phone.label'),
    controller: controller,
    validator: validatePhone,
    textInputType: TextInputType.phone,
    isNumeric: true,
    icon: Icons.phone_outlined,
  );
}

class PasswordInput extends StatelessWidget {
  final TextEditingController controller;
  const PasswordInput({super.key, required this.controller});
  @override
  Widget build(BuildContext context) => CustomInput(
    hintText: context.tr('input.password.label'),
    controller: controller,
    validator: (v) {
      final value = (v ?? '').trim();
      if (value.length < 6)
        return context.tr('input.password.error.min_length');
      return null;
    },
    textInputType: TextInputType.visiblePassword,
    obscureText: true,
    passwordVisibility: true,
    icon: Icons.lock_outlined,
  );
}
