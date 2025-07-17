import 'package:dio/dio.dart';
import '../../../../../app/shared/services/hive_service.dart';
import '../../models/chat_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> getChats();
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio dio;

  ChatRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ChatModel>> getChats() async {
    final user = HiveService.getUser();
    final token = user?.token;
    if (token == null) {
      throw Exception("User not logged in or token missing");
    }

    final response = await dio.get(
      '/ai/chats',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data as List;
      return data.map((json) => ChatModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch chat sessions');
    }
  }
}
