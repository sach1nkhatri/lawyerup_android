import '../repositories/splash_repository.dart';

class CompleteOnboarding {
  final SplashRepository repository;

  CompleteOnboarding(this.repository);

  Future<void> call() async {
    await repository.completeOnboarding();
  }
}
