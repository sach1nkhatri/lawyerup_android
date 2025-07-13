import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lawyerup_android/features/auth/domain/entities/user_entity.dart';
import 'package:lawyerup_android/features/auth/domain/usecases/signup_usecase.dart';
import 'package:lawyerup_android/features/auth/presentation/bloc/signup_cubit.dart';
import 'package:lawyerup_android/features/auth/presentation/bloc/signup_state.dart';

class MockSignupUseCase extends Mock implements SignupUseCase {}

class MockHiveBox extends Mock implements Box {}

class FakeUserEntity extends Fake implements UserEntity {}

void main() {
  late SignupCubit signupCubit;
  late MockSignupUseCase mockSignupUseCase;
  late MockHiveBox mockHiveBox;

  const testName = 'Test User';
  const testEmail = 'test@example.com';
  const testPassword = 'password123';
  const testRole = 'user';
  const testPhone = '9800000000';

  final testUser = UserEntity(
    uid: '123',
    fullName: testName,
    email: testEmail,
    token: 'fake_token_123',
    role: testRole,
    contactNumber: testPhone,
  );

  setUpAll(() {
    registerFallbackValue(FakeUserEntity());
  });

  setUp(() {
    mockSignupUseCase = MockSignupUseCase();
    mockHiveBox = MockHiveBox();
    signupCubit = SignupCubit(mockSignupUseCase);
  });

  tearDown(() => signupCubit.close());

  group('SignupCubit', () {
    test('initial state is SignupInitial', () {
      expect(signupCubit.state, SignupInitial());
    });

    blocTest<SignupCubit, SignupState>(
      'emits [SignupLoading, SignupSuccess] when signup succeeds',
      build: () {
        when(() => mockSignupUseCase(
          fullName: testName,
          email: testEmail,
          password: testPassword,
          role: testRole,
          contactNumber: testPhone,
        )).thenAnswer((_) async => testUser);

        when(() => Hive.box('settingsBox')).thenReturn(mockHiveBox);
        when(() => mockHiveBox.put(any(), any()))
            .thenAnswer((_) async => null);

        return signupCubit;
      },
      act: (cubit) => cubit.signup(
        fullName: testName,
        email: testEmail,
        password: testPassword,
        role: testRole,
        contactNumber: testPhone,
      ),
      expect: () => [
        SignupLoading(),
        SignupSuccess(testUser),
      ],
    );

    blocTest<SignupCubit, SignupState>(
      'emits [SignupLoading, SignupError] when signup fails',
      build: () {
        when(() => mockSignupUseCase(
          fullName: testName,
          email: testEmail,
          password: testPassword,
          role: testRole,
          contactNumber: testPhone,
        )).thenThrow(Exception('Signup failed'));

        return signupCubit;
      },
      act: (cubit) => cubit.signup(
        fullName: testName,
        email: testEmail,
        password: testPassword,
        role: testRole,
        contactNumber: testPhone,
      ),
      expect: () => [
        SignupLoading(),
        isA<SignupError>(),
      ],
    );
  });
}
