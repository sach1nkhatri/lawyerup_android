import '../entities/news.dart';
import '../repositories/news_repository.dart';

class GetAllNews {
  final NewsRepository repository;

  GetAllNews(this.repository);

  Future<List<News>> call() async {
    return await repository.getAllNews();
  }
}
