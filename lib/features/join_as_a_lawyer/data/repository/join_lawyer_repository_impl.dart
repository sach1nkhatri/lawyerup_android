import '../../domain/entity/lawyer_application.dart';
import '../datasources/join_lawyer_remote_data_source.dart';
import 'join_lawyer_repository.dart';

class JoinLawyerRepositoryImpl implements JoinLawyerRepository {
  final JoinLawyerRemoteDataSource remoteDataSource;

  JoinLawyerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> submitApplication(LawyerApplication application, String token) {
    return remoteDataSource.submitLawyerApplication(application, token);
  }
}
