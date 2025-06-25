import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_all_news.dart';
import 'news_event.dart';
import 'news_state.dart';


class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetAllNews getAllNews;

  NewsBloc(this.getAllNews) : super(NewsInitial()) {
    on<LoadNews>(_onLoadNews);
  }

  Future<void> _onLoadNews(LoadNews event, Emitter<NewsState> emit) async {
    emit(NewsLoading());
    try {
      final newsList = await getAllNews();
      emit(NewsLoaded(newsList));
    } catch (e) {
      emit(NewsError('Failed to load news'));
    }
  }
}
