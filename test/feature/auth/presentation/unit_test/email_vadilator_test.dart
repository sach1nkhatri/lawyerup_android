import 'package:flutter_test/flutter_test.dart';

/// Basic email validator for testing
String? validateEmail(String? email) {
  if (email == null || email.isEmpty) return 'Email is required';
  if (!email.contains('@')) return 'Invalid email';
  return null;
}

void main() {
  group('Email Validator', () {
    test('returns error for null email', () {
      expect(validateEmail(null), 'Email is required');
    });

    test('returns error for empty email', () {
      expect(validateEmail(''), 'Email is required');
    });

    test('returns error for invalid email', () {
      expect(validateEmail('invalidEmail'), 'Invalid email');
    });

    test('returns null for valid email', () {
      expect(validateEmail('test@example.com'), null);
    });
  });
}
