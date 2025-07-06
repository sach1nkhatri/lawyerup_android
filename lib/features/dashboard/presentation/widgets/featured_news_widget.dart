import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lawyerup_android/features/news/data/models/news_model.dart';
import 'package:lawyerup_android/features/news/data/repositories/news_repository_impl.dart';
import 'package:lawyerup_android/features/news/presentation/pages/news_page.dart';
import 'package:lawyerup_android/features/news/presentation/widgets/news_article_card.dart';

import '../../../news/data/datasources/remote/news_remote_data_source_impl.dart';

class FeaturedNewsWidget extends StatefulWidget {
  const FeaturedNewsWidget({super.key});

  @override
  State<FeaturedNewsWidget> createState() => _FeaturedNewsWidgetState();
}

class _FeaturedNewsWidgetState extends State<FeaturedNewsWidget> {
  NewsModel? featuredNews;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadFeaturedNews();
  }

  Future<void> loadFeaturedNews() async {
    try {
      final repo = NewsRepositoryImpl(NewsRemoteDataSourceImpl(Dio()));

      final allNews = await repo.getAllNews() as List<NewsModel>;

      final firstFeatured = allNews.firstWhere(
            (news) => news.title.toLowerCase().contains('featured'),
        orElse: () => allNews.isNotEmpty
            ? allNews.first
            : throw Exception('No news available'),
      );

      setState(() {
        featuredNews = firstFeatured;
        loading = false;
      });
    } catch (e) {
      print("Error loading featured news: $e");
      setState(() {
        error = "Unable to load featured news.";
        loading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Text(
          error!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (featuredNews == null) {
      return const Text("No featured news found.");
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NewsPage()),
        );
      },
      child: NewsArticleCard(
        title: featuredNews!.title,
        summary: featuredNews!.summary,
        image: featuredNews!.image,
        likes: featuredNews!.likes,
        dislikes: featuredNews!.dislikes,
        author: featuredNews!.author,
        date: DateTime.tryParse(featuredNews!.date) ?? DateTime.now(),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewsPage()),
          );
        },
      ),
    );
  }
}
