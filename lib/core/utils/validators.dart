String? validateName(String? value, {int minLength = 2, int maxLength = 100}) {
  final v = (value ?? '').trim();
  if (v.isEmpty) return 'El nombre es obligatorio';
  if (v.length < minLength) return 'El nombre debe tener al menos $minLength caracteres';
  if (v.length > maxLength) return 'El nombre debe tener como máximo $maxLength caracteres';
  // Permite letras acentuadas, espacios y guiones
  final regex = RegExp(r"^[A-Za-zÁÉÍÓÚáéíóúÑñ\- ]+$");
  if (!regex.hasMatch(v)) return 'Solo letras, espacios y guiones';
  return null;
}

String? validateEmail(String? value) {
  final v = (value ?? '').trim();
  if (v.isEmpty) return 'El correo es obligatorio';
  // Regex simple y robusto para emails comunes
  final regex = RegExp(r"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$");
  if (!regex.hasMatch(v)) return 'Correo inválido';
  return null;
}

String? validateDni(String? value, {bool allowLetters = false, int minLength = 7, int maxLength = 15}) {
  final v = (value ?? '').trim();
  if (v.isEmpty) return 'El DNI es obligatorio';
  final pattern = allowLetters ? r"^[A-Za-z0-9]+$" : r"^[0-9]+$";
  final regex = RegExp(pattern);
  if (!regex.hasMatch(v)) return allowLetters ? 'Solo letras y dígitos' : 'Solo dígitos';
  if (v.length < minLength) return 'El DNI debe tener al menos $minLength caracteres';
  if (v.length > maxLength) return 'El DNI debe tener como máximo $maxLength caracteres';
  return null;
}

String? validatePhone(String? value, {int minLength = 9, int maxLength = 15}) {
  final v = (value ?? '').trim();
  if (v.isEmpty) return 'El teléfono es obligatorio';
  // Permite opcional '+' al inicio y dígitos; sin espacios ni guiones
  final regex = RegExp(r"^\+?[0-9]+$");
  if (!regex.hasMatch(v)) return 'Formato inválido (usar solo dígitos, opcional +)';
  if (v.length < minLength) return 'El teléfono debe tener al menos $minLength dígitos';
  if (v.length > maxLength) return 'El teléfono debe tener como máximo $maxLength dígitos';
  return null;
}