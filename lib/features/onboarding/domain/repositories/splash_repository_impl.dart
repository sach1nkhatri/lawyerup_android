import '../../../splash/data/datasources/local/splash_local_data_source.dart';
import '../../domain/repositories/splash_repository.dart';

class SplashRepositoryImpl implements SplashRepository {
  final SplashLocalDataSource localDataSource;

  SplashRepositoryImpl(this.localDataSource);

  @override
  Future<bool> checkIfFirstLaunch() {
    return localDataSource.checkIfFirstLaunch();
  }

  @override
  Future<void> completeOnboarding() {
    return localDataSource.completeOnboarding();
  }
}
