import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../app/constant/api_endpoints.dart';
import '../../domain/entity/lawyer_application.dart';
import '../models/lawyer_application_model.dart';
import 'join_lawyer_remote_data_source.dart';

class JoinLawyerRemoteDataSourceImpl implements JoinLawyerRemoteDataSource {
  final http.Client client;

  JoinLawyerRemoteDataSourceImpl({required this.client});

  @override
  Future<void> submitLawyerApplication(LawyerApplication application, String token) async {
    final uri = Uri.parse('${ApiEndpoints.baseUrl}/lawyers');

    final request = await LawyerApplicationModel.toMultipartRequest(uri, application, token);

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode >= 400) {
      throw Exception('Failed to submit lawyer application');
    }
  }
}
