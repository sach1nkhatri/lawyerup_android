import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/check_first_launch.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final CheckFirstLaunch checkFirstLaunch;

  SplashCubit({required this.checkFirstLaunch}) : super(SplashInitial());

  Future<void> checkLaunchStatus() async {
    emit(SplashLoading());
    try {
      final status = await checkFirstLaunch();
      emit(SplashLoaded(status));
    } catch (e) {
      emit(SplashError("Something went wrong"));
    }
  }
}
