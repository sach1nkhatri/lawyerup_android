import '../../models/news_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<NewsModel>> getAllNews();
}

