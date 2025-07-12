import '../../domain/entity/lawyer_application.dart';

abstract class JoinLawyerRemoteDataSource {
  Future<void> submitLawyerApplication(LawyerApplication application, String token);
}
