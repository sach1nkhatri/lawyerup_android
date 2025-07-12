import 'package:flutter_test/flutter_test.dart';

String? validateEmail(String? email) {
  if (email == null || !email.contains('@')) return 'Invalid email';
  return null;
}

void main() {
  test('returns error for invalid email', () {
    expect(validateEmail('invalid'), 'Invalid email');
  });

  test('returns null for valid email', () {
    expect(validateEmail('test@example.com'), null);
  });
}
