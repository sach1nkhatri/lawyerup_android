import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class SignupState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {
  final UserEntity user;
  SignupSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class SignupError extends SignupState {
  final String message;
  SignupError(this.message);

  @override
  List<Object?> get props => [message];
}
