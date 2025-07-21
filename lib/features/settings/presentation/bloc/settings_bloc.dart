import 'package:flutter_bloc/flutter_bloc.dart';
import 'settings_bloc_event.dart';
import 'settings_bloc_state.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetCurrentUserUseCase getCurrentUser;
  final UpdateUserProfileUseCase updateUser;

  SettingsBloc({
    required this.getCurrentUser,
    required this.updateUser,
  }) : super(SettingsInitial()) {
    on<LoadSettingsUser>(_onLoadSettingsUser);
    on<SaveSettingsUserProfile>(_onSaveSettingsUserProfile);
  }

  Future<void> _onLoadSettingsUser(
      LoadSettingsUser event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    try {
      final user = await getCurrentUser();
      emit(SettingsLoaded(user));
    } catch (e) {
      emit(SettingsError("Failed to load user data"));
    }
  }

  Future<void> _onSaveSettingsUserProfile(
      SaveSettingsUserProfile event, Emitter<SettingsState> emit) async {
    emit(SettingsUpdating());
    try {
      await updateUser(
        contactNumber: event.contactNumber,
        state: event.state,
        city: event.city,
        address: event.address,
      );
      final updatedUser = await getCurrentUser();
      emit(SettingsLoaded(updatedUser));
      emit(SettingsUpdateSuccess());
    } catch (e) {
      emit(SettingsError("Failed to update user profile"));
    }
  }
}
