import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../data/models/user_model.dart'; // adjust path if needed
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      final user = await loginUseCase(email, password);
      final model = user as UserModel;

      // Save token & user to Hive
      final box = Hive.box('settingsBox');
      await box.put('lawyerup_token', model.token);
      await box.put('lawyerup_user', model.toJson());
      await box.put('isLoggedIn', true);

      emit(LoginSuccess());
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}
