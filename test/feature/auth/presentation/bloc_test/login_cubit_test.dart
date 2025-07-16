import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:lawyerup_android/features/auth/domain/usecases/login_usecase.dart';
import 'package:lawyerup_android/features/auth/data/models/user_model.dart';
import 'package:lawyerup_android/features/auth/presentation/bloc/login_cubit.dart';
import 'package:lawyerup_android/features/auth/presentation/bloc/login_state.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockHiveBox extends Mock implements Box {}

void main() {
  late LoginCubit loginCubit;
  late MockLoginUseCase mockLoginUseCase;
  late MockHiveBox mockHiveBox;

  const testEmail = 'test@example.com';
  const testPassword = 'password123';

  final testUser = UserModel(
    uid: '123',
    fullName: 'Test User',
    email: testEmail,
    token: 'fake_token_123',
    role: 'user',
    contactNumber: '9810392313'
  );

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockHiveBox = MockHiveBox();

    loginCubit = LoginCubit(mockLoginUseCase, mockHiveBox);
  });

  tearDown(() => loginCubit.close());

  group('LoginCubit', () {
    test('initial state is LoginInitial', () {
      expect(loginCubit.state, LoginInitial());
    });

    blocTest<LoginCubit, LoginState>(
      'emits [LoginLoading, LoginSuccess] on successful login',
      build: () {
        when(() => mockLoginUseCase(testEmail, testPassword))
            .thenAnswer((_) async => testUser);

        when(() => mockHiveBox.put(any(), any()))
            .thenAnswer((_) async => null);

        return LoginCubit(mockLoginUseCase, mockHiveBox);
      },
      act: (cubit) => cubit.login(testEmail, testPassword),
      expect: () => [
        LoginLoading(),
        LoginSuccess(),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [LoginLoading, LoginError] on login failure',
      build: () {
        when(() => mockLoginUseCase(testEmail, testPassword))
            .thenThrow(Exception('Login failed'));

        return LoginCubit(mockLoginUseCase, mockHiveBox);
      },
      act: (cubit) => cubit.login(testEmail, testPassword),
      expect: () => [
        LoginLoading(),
        isA<LoginError>(),
      ],
    );
  });
}
