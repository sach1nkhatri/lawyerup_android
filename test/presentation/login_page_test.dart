import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lawyerup_android/features/auth/presentation/pages/login_page.dart';


void main() {
  testWidgets('Login button is present', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    expect(find.text('Login'), findsOneWidget);
  });
}
