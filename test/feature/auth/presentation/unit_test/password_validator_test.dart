import 'package:flutter_test/flutter_test.dart';

/// Basic password validator for testing
String? validatePassword(String? password) {
  if (password == null || password.isEmpty) return 'Password is required';
  if (password.length < 6) return 'Password too short';
  return null;
}

void main() {
  group('Password Validator', () {
    test('returns error for null password', () {
      expect(validatePassword(null), 'Password is required');
    });

    test('returns error for empty password', () {
      expect(validatePassword(''), 'Password is required');
    });

    test('returns error for short password', () {
      expect(validatePassword('123'), 'Password too short');
    });

    test('returns null for valid password', () {
      expect(validatePassword('secure123'), null);
    });
  });
}
