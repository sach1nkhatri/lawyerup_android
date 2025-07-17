import 'package:dio/dio.dart';
import '../../../../../app/constant/api_endpoints.dart';
import '../../../../../app/shared/services/hive_service.dart';
import '../../models/chat_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> getChats();
  Future<void> deleteChat(String chatId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio dio;

  ChatRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ChatModel>> getChats() async {
    final token = HiveService.getUser()?.token;
    if (token == null) throw Exception("No token found in Hive.");

    final response = await dio.get(
      '/ai/chats', //
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }),
    );

    if (response.statusCode == 200) {
      final data = response.data as List;
      return data.map((json) => ChatModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load chats');
    }
  }

  @override
  Future<void> deleteChat(String chatId) async {
    final token = HiveService.getUser()?.token;
    if (token == null) throw Exception("No token found in Hive.");

    final response = await dio.delete(
      ApiEndpoints.deleteChat(chatId),
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete chat');
    }
  }
}
