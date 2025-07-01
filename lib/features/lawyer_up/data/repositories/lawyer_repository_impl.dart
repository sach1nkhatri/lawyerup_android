import '../../domain/entities/lawyer.dart';
import '../../domain/repositories/lawyer_repository.dart';
import '../datasources/remote/lawyer_remote_data_source.dart';

class LawyerRepositoryImpl implements LawyerRepository {
  final LawyerRemoteDataSource remoteDataSource;

  LawyerRepositoryImpl(this.remoteDataSource);

  @override
  Future<Lawyer> getLawyerDetail(String lawyerId) async {
    final model = await remoteDataSource.getLawyerDetail(lawyerId);

    // Extract specialization from the latest education
    String specialization = model.education.isNotEmpty
        ? model.education.last.specialization
        : 'N/A';

    // Map root-level specialization to barRegNumber (temporary use)
    String barRegNumber = model.specialization;

    return Lawyer(
      id: model.id,
      fullName: model.fullName,
      specialization: specialization,
      barRegNumber: barRegNumber,
      email: model.email,
      phone: model.phone,
      address: model.address,
      city: model.city,
      state: model.state,
      profilePhoto: model.profilePhoto,
      licenseFile: model.licenseFile,
      description: model.description,
      specialCase: model.specialCase,
      socialLink: model.socialLink,
      workExperience: model.workExperience,
      education: model.education,
      schedule: model.schedule,
      reviews: model.reviews,
    );
  }

  @override
  Future<List<Lawyer>> getAllLawyers() async {
    final models = await remoteDataSource.getAllLawyers();

    return models.map((model) {
      String specialization = model.education.isNotEmpty
          ? model.education.last.specialization
          : 'N/A';

      return Lawyer(
        id: model.id,
        fullName: model.fullName,
        specialization: specialization,
        barRegNumber: model.specialization,
        email: model.email,
        phone: model.phone,
        address: model.address,
        city: model.city,
        state: model.state,
        profilePhoto: model.profilePhoto,
        licenseFile: model.licenseFile,
        description: model.description,
        specialCase: model.specialCase,
        socialLink: model.socialLink,
        workExperience: model.workExperience,
        education: model.education,
        schedule: model.schedule,
        reviews: model.reviews,
      );
    }).toList();
  }
}
