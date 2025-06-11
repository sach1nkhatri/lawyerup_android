import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_status.dart';
import '../../domain/usecases/check_first_launch.dart';


part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final CheckFirstLaunchUseCase checkFirstLaunchUseCase;

  SplashCubit(this.checkFirstLaunchUseCase) : super(SplashInitial());

  Future<void> decideNavigation() async {
    final status = await checkFirstLaunchUseCase();
    if (status == UserStatus.loggedIn) {
      emit(SplashNavigateToLogin());
    } else if (status == UserStatus.tutorialCompleted) {
      emit(SplashNavigateToLogin());
    } else {
      emit(SplashNavigateToWelcome());
    }
  }
}
