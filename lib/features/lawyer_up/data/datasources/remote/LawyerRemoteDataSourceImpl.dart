import '../../../../../app/constant/api_endpoints.dart';
import '../../../../../core/network/dio_client.dart';
import '../../models/lawyer_model.dart';
import 'lawyer_remote_data_source.dart';

class LawyerRemoteDataSourceImpl implements LawyerRemoteDataSource {
  final DioClient dioClient;

  LawyerRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<LawyerModel>> getAllLawyers() async {
    final response = await dioClient.dio.get(ApiEndpoints.getAllLawyers);

    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((json) => LawyerModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch lawyers: ${response.statusCode}");
    }
  }

  @override
  Future<LawyerModel> getLawyerDetail(String lawyerId) async {
    final response =
    await dioClient.dio.get('${ApiEndpoints.getLawyerById}$lawyerId');

    if (response.statusCode == 200) {
      return LawyerModel.fromJson(response.data);
    } else {
      throw Exception("Failed to fetch lawyer detail: ${response.statusCode}");
    }
  }
}
