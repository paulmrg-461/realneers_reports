import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextInput extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final int? maxLength;

  const AppTextInput({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      enabled: enabled,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: const OutlineInputBorder(),
      ),
    );
  }
}