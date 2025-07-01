import '../entities/lawyer.dart';

abstract class LawyerRepository {
  Future<Lawyer> getLawyerDetail(String lawyerId);
  Future<List<Lawyer>> getAllLawyers(); // <-- Required for listing
}

