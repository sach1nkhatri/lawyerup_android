import 'package:dio/dio.dart';
import '../../../../../app/constant/api_endpoints.dart';
import '../../../../../app/shared/services/hive_service.dart';
import '../../models/settings_user_model.dart';
import 'settings_user_remote_data_source.dart';

class SettingsUserRemoteDataSourceImpl implements SettingsUserRemoteDataSource {
  final Dio dio;

  SettingsUserRemoteDataSourceImpl({required this.dio});

  @override
  Future<SettingsUserModel> getCurrentUser() async {
    final token = HiveService.getUser()?.token;

    if (token == null) {
      throw Exception('User not logged in');
    }

    final res = await dio.get(
      ApiEndpoints.currentUser,
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }),
    );

    return SettingsUserModel.fromJson(res.data);
  }

  @override
  Future<void> updateUserProfile({
    required String contactNumber,
    required String state,
    required String city,
    required String address,
  }) async {
    final token = HiveService.getUser()?.token;

    if (token == null) {
      throw Exception('User token not found');
    }

    await dio.patch(
      ApiEndpoints.updateProfile,
      data: {
        'contactNumber': contactNumber,
        'state': state,
        'city': city,
        'address': address,
      },
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }),
    );
  }
}
