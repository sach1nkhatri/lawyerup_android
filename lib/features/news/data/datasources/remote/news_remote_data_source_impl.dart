import 'package:dio/dio.dart';
import '../../../../../app/constant/api_endpoints.dart';
import '../../models/news_model.dart';
import 'news_remote_data_source.dart';

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final Dio dio;

  NewsRemoteDataSourceImpl(this.dio);

  @override
  Future<List<NewsModel>> getAllNews() async {
    final res = await dio.get(ApiEndpoints.getAllNews);
    return (res.data as List).map((e) => NewsModel.fromJson(e)).toList();
  }

  // ✅ Add Comment
  Future<List<Map<String, dynamic>>> addComment({
    required String newsId,
    required String commentText,
    required String token,
  }) async {
    final res = await dio.post(
      ApiEndpoints.commentNews(newsId),
      data: {'text': commentText},
      options: Options(
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      ),
    );

    return List<Map<String, dynamic>>.from(res.data['comments']);
  }
}
