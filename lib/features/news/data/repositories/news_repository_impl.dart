import '../../domain/entities/news.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/remote/news_remote_data_source.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remote;

  NewsRepositoryImpl(this.remote);

  @override
  Future<List<News>> getAllNews() => remote.getAllNews();
}
