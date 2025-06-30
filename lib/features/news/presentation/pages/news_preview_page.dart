import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/constant/api_endpoints.dart';
import '../../../../app/service_locater/service_locator.dart';
import '../../domain/entities/news.dart';
import '../bloc/news_preview_bloc.dart';
import '../bloc/news_preview_event.dart';
import '../bloc/news_preview_state.dart';

class NewsPreviewPage extends StatelessWidget {
  final News news;
  final String token;
  final String userId;

  const NewsPreviewPage({
    super.key,
    required this.news,
    required this.token,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NewsPreviewBloc>(param1: token, param2: userId)
        ..add(InitPreview(news)),
      child: const _NewsPreviewView(),
    );
  }
}

class _NewsPreviewView extends StatefulWidget {
  const _NewsPreviewView({super.key});

  @override
  State<_NewsPreviewView> createState() => _NewsPreviewViewState();
}

class _NewsPreviewViewState extends State<_NewsPreviewView> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsPreviewBloc, NewsPreviewState>(
      builder: (context, state) {
        if (state is NewsPreviewLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (state is NewsPreviewLoaded) {
          final news = state.news;
          final imageUrl = "${ApiEndpoints.baseHost}${news.image}";

          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF1C2D3D),
              iconTheme: const IconThemeData(color: Colors.white), // back button color
              title: Text(
                news.title,
                style: const TextStyle(
                  fontFamily: 'Lora',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // title text color
                ),
              ),
            ),
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xA0BCF1EB),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(imageUrl, fit: BoxFit.cover),
                          ),
                          const SizedBox(height: 8),
                          Text('by ${news.author} • ${_formatDate(news.date)}',
                              style: const TextStyle(fontFamily: 'PlayfairDisplay', color: Colors.black)),
                          const SizedBox(height: 8),
                          Text(news.summary, style: const TextStyle(fontFamily: 'PlayfairDisplay')),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.thumb_up_alt_outlined, color: Colors.green),
                                onPressed: () => context.read<NewsPreviewBloc>().add(LikePressed()),
                              ),
                              Text('${news.likes}', style: const TextStyle(fontFamily: 'PlayfairDisplay')),
                              const SizedBox(width: 16),
                              IconButton(
                                icon: const Icon(Icons.thumb_down_alt_outlined, color: Colors.red),
                                onPressed: () => context.read<NewsPreviewBloc>().add(DislikePressed()),
                              ),
                              Text('${news.dislikes}', style: const TextStyle(fontFamily: 'PlayfairDisplay')),
                            ],
                          ),
                          if (state.error != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(state.error!, style: const TextStyle(color: Colors.red)),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Comments', style: TextStyle(fontFamily: 'Lora', fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          news.comments.isEmpty
                              ? const Text("No comments yet.", style: TextStyle(fontFamily: 'PlayfairDisplay'))
                              : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: news.comments.length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (_, index) {
                              final comment = news.comments[index];
                              return ListTile(
                                title: Text(comment['text'], style: const TextStyle(fontFamily: 'PlayfairDisplay')),
                                subtitle: Text('— ${comment['user']}',
                                    style: const TextStyle(fontFamily: 'PlayfairDisplay', fontSize: 13)),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          SafeArea(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: TextField(
                                      controller: _controller,
                                      minLines: 1,
                                      maxLines: 4,
                                      style: const TextStyle(fontFamily: 'PlayfairDisplay'),
                                      decoration: const InputDecoration(
                                        hintText: "Add a comment",
                                        border: InputBorder.none,
                                        isCollapsed: true,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.send, color: Colors.deepPurple),
                                    onPressed: () {
                                      final text = _controller.text.trim();
                                      if (text.isNotEmpty) {
                                        context.read<NewsPreviewBloc>().add(SubmitComment(text));
                                        _controller.clear();
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.tryParse(dateString);
    if (date == null) return '';
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
