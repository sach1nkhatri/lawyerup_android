import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../data/models/user_model.dart';
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

      // Save token & user to Hive
      final model = user as UserModel;
      final box = Hive.box('settingsBox');
      await box.put('lawyerup_token', model.token); // if backend returns token
      await box.put('lawyerup_user', model.toJson());
      await box.put('isLoggedIn', true);

      emit(SignupSuccess(user));
    } catch (e) {
      emit(SignupError(e.toString()));
    }
  }
}
