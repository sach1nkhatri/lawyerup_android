import 'package:dio/dio.dart';
import '../../models/news_model.dart';
import 'news_remote_data_source.dart';


// class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
//   final http.Client client;
//
//   NewsRemoteDataSourceImpl(this.client);
//
//   @override
//   Future<List<NewsModel>> getAllNews() async {
//     final response = await client.get(Uri.parse('${ApiEndpoints.baseUrl}news'));
//
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       return data.map((json) => NewsModel.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load news');
//     }
//   }
// }
class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final Dio dio;

  NewsRemoteDataSourceImpl(this.dio);

  @override
  Future<List<NewsModel>> getAllNews() async {
    final res = await dio.get("news");
    return (res.data as List).map((e) => NewsModel.fromJson(e)).toList();
  }
}
