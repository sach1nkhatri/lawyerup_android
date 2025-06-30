import '../../domain/entities/news.dart';

abstract class NewsPreviewState {}

class NewsPreviewLoading extends NewsPreviewState {}

class NewsPreviewLoaded extends NewsPreviewState {
  final News news;
  final String? error;

  NewsPreviewLoaded({required this.news, this.error});
}
