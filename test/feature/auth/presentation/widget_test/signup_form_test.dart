import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lawyerup_android/features/auth/presentation/widgets/signup_form.dart';

void main() {
  group('SignupForm Widget Test', () {
    testWidgets('fills all fields, selects role, and submits', (tester) async {
      // Controllers
      final nameController = TextEditingController();
      final emailController = TextEditingController();
      final phoneController = TextEditingController();
      final passwordController = TextEditingController();
      final confirmController = TextEditingController();

      String selectedRole = 'user';
      bool onSubmitCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 1600)),
            child: Scaffold(
              body: SingleChildScrollView( // ✅ fixes layout overflow in tests
                child: SignupForm(
                  nameController: nameController,
                  emailController: emailController,
                  phoneController: phoneController,
                  passwordController: passwordController,
                  confirmController: confirmController,
                  selectedRole: selectedRole,
                  onRoleChanged: (val) => selectedRole = val ?? 'user',
                  onSubmit: () => onSubmitCalled = true,
                  isLoading: false,
                ),
              ),
            ),
          ),
        ),
      );

      // Fill all fields by hint text
      await tester.enterText(find.widgetWithText(TextField, 'Username or Email'), 'sachin@example.com');
      await tester.enterText(find.widgetWithText(TextField, 'Full Name'), 'Sachin Khatri');
      await tester.enterText(find.widgetWithText(TextField, 'Phone Number'), '9800000000');
      await tester.enterText(find.widgetWithText(TextField, 'Password'), 'password123');
      await tester.enterText(find.widgetWithText(TextField, 'Confirm Password'), 'password123');

      // Change dropdown value to 'lawyer'
      await tester.tap(find.text('user')); // current selected
      await tester.pumpAndSettle();
      await tester.tap(find.text('lawyer').last);
      await tester.pumpAndSettle();

      // Tap Register
      await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
      await tester.pump();

      // ✅ Assert submit was triggered
      expect(onSubmitCalled, isTrue);

      // ✅ Assert controller values
      expect(nameController.text, 'Sachin Khatri');
      expect(emailController.text, 'sachin@example.com');
      expect(phoneController.text, '9800000000');
    });
  });
}
