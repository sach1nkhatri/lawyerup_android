import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/signup_usecase.dart';
import 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignupUseCase signupUseCase;

  SignupCubit(this.signupUseCase) : super(SignupInitial());

  Future<void> signup({
    required String fullName,
    required String email,
    required String password,
    required String role,
    required String contactNumber,
  }) async {
    emit(SignupLoading());
    try {
      final user = await signupUseCase(
        fullName: fullName,
        email: email,
        password: password,
        role: role,
        contactNumber: contactNumber,
      );
      emit(SignupSuccess(user));
    } catch (e) {
      emit(SignupError(e.toString()));
    }
  }
}
