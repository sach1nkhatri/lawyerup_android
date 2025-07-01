import '../entities/lawyer.dart';
import '../repositories/lawyer_repository.dart';

class GetLawyerDetail {
  final LawyerRepository repository;

  GetLawyerDetail(this.repository);

  Future<Lawyer> call(String lawyerId) {
    return repository.getLawyerDetail(lawyerId);
  }
}
