
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingCubit extends Cubit<int> {
  OnboardingCubit() : super(0); // Tracks current step

  void nextStep() => emit(state + 1);
  void previousStep() => emit(state - 1);
  void reset() => emit(0);
}
