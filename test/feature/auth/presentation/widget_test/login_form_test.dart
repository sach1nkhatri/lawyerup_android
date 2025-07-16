import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lawyerup_android/features/auth/presentation/widgets/login_form.dart';

void main() {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late bool loginCalled;

  setUp(() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    loginCalled = false;
  });

  tearDown(() {
    emailController.dispose();
    passwordController.dispose();
  });

  Widget buildTestableWidget({bool isLoading = false}) {
    return MaterialApp(
      home: LoginForm(
        emailController: emailController,
        passwordController: passwordController,
        isLoading: isLoading,
        onLogin: () {
          loginCalled = true;
        },
      ),
    );
  }

  group('LoginForm Widget Tests', () {
    testWidgets('renders email and password fields', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget());

      expect(find.byKey(const Key('emailField')), findsOneWidget);
      expect(find.byKey(const Key('passwordField')), findsOneWidget);
    });

    testWidgets('allows user to enter email and password', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget());

      await tester.enterText(find.byKey(const Key('emailField')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('passwordField')), 'password123');

      expect(emailController.text, 'test@example.com');
      expect(passwordController.text, 'password123');
    });

    testWidgets('calls onLogin when login button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget());

      await tester.enterText(find.byKey(const Key('emailField')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('passwordField')), 'password123');

      // 👇 tap the InkWell containing Icon
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pump();

      expect(loginCalled, isTrue);
    });

    testWidgets('shows loading spinner when isLoading is true', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(isLoading: true));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsNothing);
    });
  });
}
