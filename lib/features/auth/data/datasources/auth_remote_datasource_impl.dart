
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final String baseUrl = 'http://localhost:3000/api/v1/';

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('\${baseUrl}auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body)['user']);
    } else {
      throw Exception('Login failed: \${response.body}');
    }
  }

  @override
  Future<UserModel> signup({
    required String fullName,
    required String email,
    required String password,
    required String role,
    required String contactNumber,
  }) async {
    final response = await http.post(
      Uri.parse('\${baseUrl}auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fullName': fullName,
        'email': email,
        'password': password,
        'role': role,
        'contactNumber': contactNumber,
      }),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body)['user']);
    } else {
      throw Exception('Signup failed: \${response.body}');
    }
  }
}
