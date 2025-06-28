import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/service_locater/service_locator.dart';
import '../../domain/entities/news.dart';
import '../bloc/news_bloc.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';
import '../widgets/news_article_card.dart';
import 'news_preview_page.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NewsBloc>()..add(LoadNews()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E2B3A),
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "News & Article",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: BlocBuilder<NewsBloc, NewsState>(
          builder: (context, state) {
            if (state is NewsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NewsLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.newsList.length,
                itemBuilder: (context, index) {
                  final News news = state.newsList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NewsPreviewPage(newsId: news.id),
                        ),
                      );
                    },
                    child: NewsCard(
                      date: news.date,
                      title: news.title,
                      description: news.summary,
                      likes: news.likes,
                      dislikes: news.dislikes,
                    ),
                  );
                },
              );
            } else if (state is NewsError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
