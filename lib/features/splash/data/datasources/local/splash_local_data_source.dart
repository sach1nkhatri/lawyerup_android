import '../../../domain/entities/user_status.dart';

abstract class SplashLocalDataSource {
  Future<UserStatus> getUserStatus();
}
