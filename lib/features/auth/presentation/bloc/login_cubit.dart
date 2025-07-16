import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../domain/usecases/login_usecase.dart';
import '../../data/models/user_model.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;
  final Box box; // Inject this

  LoginCubit(this.loginUseCase, this.box) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      final user = await loginUseCase(email, password);
      final model = UserModel.fromEntity(user);

      await box.put('lawyerup_token', model.token);
      await box.put('lawyerup_user', model.toJson());
      await box.put('isLoggedIn', true);

      emit(LoginSuccess());
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}

