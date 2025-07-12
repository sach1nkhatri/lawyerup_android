import 'package:flutter_test/flutter_test.dart';
import 'package:lawyerup_android/features/auth/presentation/bloc/login_cubit.dart';
import 'package:lawyerup_android/features/auth/presentation/bloc/login_state.dart';


void main() {
  group('LoginCubit', () {
    late LoginCubit loginCubit;

    setUp(() {
      loginCubit = LoginCubit();
    });

    blocTest<LoginCubit, LoginState>(
      'emits [LoginLoading, LoginSuccess] when login succeeds',
      build: () => loginCubit,
      act: (cubit) => cubit.loginUser(email: 'test@example.com', password: 'password'),
      expect: () => [isA<LoginLoading>(), isA<LoginSuccess>()],
    );
  });
}
