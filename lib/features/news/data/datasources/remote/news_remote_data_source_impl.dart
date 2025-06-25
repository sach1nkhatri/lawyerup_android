import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../app/constant/api_endpoints.dart';
import '../../models/news_model.dart';
import 'news_remote_data_source.dart';


class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final http.Client client;

  NewsRemoteDataSourceImpl(this.client);

  @override
  Future<List<NewsModel>> getAllNews() async {
    final response = await client.get(Uri.parse('${ApiEndpoints.baseUrl}news'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => NewsModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
