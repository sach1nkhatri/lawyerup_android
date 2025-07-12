import '../../domain/entity/lawyer_application.dart';

abstract class JoinLawyerRepository {
  Future<void> submitApplication(LawyerApplication application, String token);
}
