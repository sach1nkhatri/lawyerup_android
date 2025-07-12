import 'package:flutter_test/flutter_test.dart';
import 'package:lawyerup_android/features/auth/presentation/bloc/signup_cubit.dart';
import 'package:lawyerup_android/features/auth/presentation/bloc/signup_state.dart';


void main() {
  group('SignupCubit', () {
    late SignupCubit signupCubit;

    setUp(() {
      signupCubit = SignupCubit();
    });

    blocTest<SignupCubit, SignupState>(
      'emits [SignupLoading, SignupSuccess] when signup succeeds',
      build: () => signupCubit,
      act: (cubit) => cubit.signupUser(name: 'John', email: 'john@example.com', password: '123456'),
      expect: () => [isA<SignupLoading>(), isA<SignupSuccess>()],
    );
  });
}
