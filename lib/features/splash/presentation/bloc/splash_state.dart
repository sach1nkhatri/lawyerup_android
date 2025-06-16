import '../../domain/entities/user_status.dart';

abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashLoaded extends SplashState {
  final UserStatus userStatus;
  SplashLoaded(this.userStatus);
}

class SplashError extends SplashState {
  final String message;
  SplashError(this.message);
}
