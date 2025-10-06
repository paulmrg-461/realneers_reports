import 'package:flutter_test/flutter_test.dart';
import 'package:realneers_reports/core/utils/validators.dart';

void main() {
  group('Name validator', () {
    test('returns error for empty', () {
      expect(validateName(''), isNotNull);
      expect(validateName('   '), isNotNull);
    });

    test('returns error for too short', () {
      expect(validateName('A'), isNotNull);
    });

    test('allows letters, spaces and accents', () {
      expect(validateName('José Pérez'), isNull);
      expect(validateName('María-Luisa'), isNull);
    });

    test('rejects digits or symbols (beyond hyphen)', () {
      expect(validateName('John123'), isNotNull);
      expect(validateName('John@Doe'), isNotNull);
    });
  });

  group('Email validator', () {
    test('valid emails pass', () {
      expect(validateEmail('user@example.com'), isNull);
      expect(validateEmail('user.name+tag@sub.domain.co'), isNull);
    });

    test('invalid emails fail', () {
      expect(validateEmail('userexample.com'), isNotNull);
      expect(validateEmail('user@'), isNotNull);
      expect(validateEmail('@example.com'), isNotNull);
    });
  });

  group('DNI validator', () {
    test('reject empty', () {
      expect(validateDni(''), isNotNull);
    });

    test('accepts digits-only between 7 and 15 by default', () {
      expect(validateDni('1234567'), isNull);
      expect(validateDni('123456789012345'), isNull);
      expect(validateDni('1234'), isNotNull);
      expect(validateDni('1234567890123456'), isNotNull);
    });

    test('rejects spaces and special chars', () {
      expect(validateDni('12 34567'), isNotNull);
      expect(validateDni('12345-67'), isNotNull);
    });

    test('allows letters when configured', () {
      expect(validateDni('1234567A', allowLetters: true), isNull);
      expect(validateDni('ABC12345', allowLetters: true), isNull);
    });
  });

  group('Phone validator', () {
    test('accepts E.164-like numbers', () {
      expect(validatePhone('+51987654321'), isNull);
      expect(validatePhone('987654321'), isNull);
    });

    test('rejects short and long numbers', () {
      expect(validatePhone('12345'), isNotNull);
      expect(validatePhone('1234567890123456'), isNotNull);
    });

    test('rejects invalid characters', () {
      expect(validatePhone('+51-987654321'), isNotNull);
      expect(validatePhone('98 765 4321'), isNotNull);
      expect(validatePhone('phone'), isNotNull);
    });
  });
}