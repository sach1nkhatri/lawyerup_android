import '../entities/lawyer.dart';
import '../repositories/lawyer_repository.dart';

class GetAllLawyers {
  final LawyerRepository repository;

  GetAllLawyers(this.repository);

  Future<List<Lawyer>> call() {
    return repository.getAllLawyers();
  }
}
