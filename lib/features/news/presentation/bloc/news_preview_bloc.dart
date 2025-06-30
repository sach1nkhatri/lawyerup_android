import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../../../../app/constant/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/news.dart';
import 'news_preview_event.dart';
import 'news_preview_state.dart';

class NewsPreviewBloc extends Bloc<NewsPreviewEvent, NewsPreviewState> {
  final Dio _dio;
  final String token;
  final String userId;

  late News _currentNews;

  NewsPreviewBloc({
    required this.token,
    required this.userId,
  })  : _dio = DioClient().dio,
        super(NewsPreviewLoading()) {
    on<InitPreview>((event, emit) {
      _currentNews = event.news;
      emit(NewsPreviewLoaded(news: _currentNews));
    });

    on<SubmitComment>(_onSubmitComment);
    on<DeleteComment>(_onDeleteComment);
    on<LikePressed>(_onLike);
    on<DislikePressed>(_onDislike);
  }

  void _onSubmitComment(SubmitComment event, Emitter emit) async {
    if (event.text.trim().isEmpty) return;
    try {
      final res = await _dio.post(
        ApiEndpoints.commentNews(_currentNews.id),
        data: {'text': event.text},
        options: Options(headers: {'Authorization': token}),
      );
      final updatedComments = List<Map<String, dynamic>>.from(res.data['comments']);
      _currentNews = _currentNews.copyWith(comments: updatedComments);
      emit(NewsPreviewLoaded(news: _currentNews));
    } catch (_) {
      emit(NewsPreviewLoaded(news: _currentNews, error: 'Failed to comment'));
    }
  }

  void _onDeleteComment(DeleteComment event, Emitter emit) async {
    try {
      final res = await _dio.delete(
        ApiEndpoints.deleteComment(_currentNews.id, event.index),
        options: Options(headers: {'Authorization': token}),
      );
      final updatedComments = List<Map<String, dynamic>>.from(res.data['comments']);
      _currentNews = _currentNews.copyWith(comments: updatedComments);
      emit(NewsPreviewLoaded(news: _currentNews));
    } catch (_) {
      emit(NewsPreviewLoaded(news: _currentNews, error: 'Failed to delete'));
    }
  }

  void _onLike(LikePressed event, Emitter emit) async {
    try {
      final res = await _dio.post(
        ApiEndpoints.likeNews(_currentNews.id),
        data: {'userId': userId},
        options: Options(headers: {'Authorization': token}),
      );
      _currentNews = _currentNews.copyWith(
        likes: res.data['likes'],
        dislikes: res.data['dislikes'],
      );
      emit(NewsPreviewLoaded(news: _currentNews));
    } catch (_) {
      emit(NewsPreviewLoaded(news: _currentNews, error: 'Failed to like'));
    }
  }

  void _onDislike(DislikePressed event, Emitter emit) async {
    try {
      final res = await _dio.post(
        ApiEndpoints.dislikeNews(_currentNews.id),
        data: {'userId': userId},
        options: Options(headers: {'Authorization': token}),
      );
      _currentNews = _currentNews.copyWith(
        likes: res.data['likes'],
        dislikes: res.data['dislikes'],
      );
      emit(NewsPreviewLoaded(news: _currentNews));
    } catch (_) {
      emit(NewsPreviewLoaded(news: _currentNews, error: 'Failed to dislike'));
    }
  }
}
