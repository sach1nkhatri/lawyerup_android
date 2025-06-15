import '../entities/user_status.dart';
import '../../data/datasources/local/splash_local_data_source.dart';

class CheckFirstLaunch {
  final SplashLocalDataSource localDataSource;

  CheckFirstLaunch(this.localDataSource);

  Future<UserStatus> call() async {
    final isFirstTime = await localDataSource.checkIfFirstLaunch();
    return isFirstTime ? UserStatus.firstTime : UserStatus.returning;
  }
}
