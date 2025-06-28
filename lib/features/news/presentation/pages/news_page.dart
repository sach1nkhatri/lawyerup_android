import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../app/service_locater/service_locator.dart';
import '../../../auth/data/models/user_hive_model.dart';
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
        appBar: AppBar(title: const Text("Latest News")),
        body: BlocBuilder<NewsBloc, NewsState>(
          builder: (context, state) {
            if (state is NewsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NewsLoaded) {
              final List<News> newsList = state.newsList;

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: newsList.length,
                itemBuilder: (_, index) {
                  final news = newsList[index];
                  return NewsArticleCard(
                    title: news.title,
                    summary: news.summary,
                    image: news.image,
                    likes: news.likes,
                    dislikes: news.dislikes,
                    author: news.author,
                    date: DateTime.parse(news.date),
                    onTap: () {
                      final userBox = Hive.box<UserHiveModel>('users');
                      final user = userBox.getAt(0);

                      if (user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("User not found in local storage.")),
                        );
                        return;
                      }

                      final token = user.token;
                      final userId = user.uid;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NewsPreviewPage(
                            news: news,
                            token: 'Bearer $token',
                            userId: userId,
                          ),
                        ),
                      );
                    },
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
