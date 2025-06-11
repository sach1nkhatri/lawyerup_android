import '../../domain/entities/user_status.dart';
import '../../data/datasources/local/splash_local_data_source.dart';

class CheckFirstLaunchUseCase {
  final SplashLocalDataSource dataSource;

  CheckFirstLaunchUseCase(this.dataSource);

  Future<UserStatus> call() async {
    return await dataSource.getUserStatus();
  }
}
