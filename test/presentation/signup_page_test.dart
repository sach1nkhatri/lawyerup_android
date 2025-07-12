import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lawyerup_android/features/auth/presentation/pages/signup_page.dart';


void main() {
  testWidgets('Signup button is present', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignupPage()));
    expect(find.text('Signup'), findsOneWidget);
  });
}
