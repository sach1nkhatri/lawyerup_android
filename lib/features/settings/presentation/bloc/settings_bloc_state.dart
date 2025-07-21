import 'package:equatable/equatable.dart';
import '../../domain/entities/settings_user_entity.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final SettingsUserEntity user;

  const SettingsLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class SettingsUpdating extends SettingsState {}

class SettingsUpdateSuccess extends SettingsState {}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
