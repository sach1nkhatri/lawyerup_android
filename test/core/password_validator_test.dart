import 'package:flutter_test/flutter_test.dart';

String? validatePassword(String? password) {
  if (password == null || password.length < 6) return 'Password too short';
  return null;
}

void main() {
  test('returns error for short password', () {
    expect(validatePassword('123'), 'Password too short');
  });

  test('returns null for valid password', () {
    expect(validatePassword('secure123'), null);
  });
}
