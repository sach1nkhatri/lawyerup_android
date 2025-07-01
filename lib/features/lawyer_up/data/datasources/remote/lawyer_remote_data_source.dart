import 'package:dio/dio.dart';
import '../../../../../app/constant/api_endpoints.dart';
import '../../models/lawyer_model.dart';

abstract class LawyerRemoteDataSource {
  Future<LawyerModel> getLawyerDetail(String lawyerId);
  Future<List<LawyerModel>> getAllLawyers();
}

class LawyerRemoteDataSourceImpl implements LawyerRemoteDataSource {
  final Dio dio;

  LawyerRemoteDataSourceImpl(this.dio);

  @override
  Future<LawyerModel> getLawyerDetail(String lawyerId) async {
    final response = await dio.get('${ApiEndpoints.getLawyerById}$lawyerId');
    return LawyerModel.fromJson(response.data);
  }

  @override
  Future<List<LawyerModel>> getAllLawyers() async {
    final response = await dio.get(ApiEndpoints.getAllLawyers);
    return (response.data as List)
        .map((json) => LawyerModel.fromJson(json))
        .toList();
  }
}
