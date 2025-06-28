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
      create: (_) => sl<NewsPreviewBloc>(param1: token, param2: userId)..add(InitPreview(news)),
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
            appBar: AppBar(title: Text(news.title)),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(imageUrl, fit: BoxFit.cover),
                  const SizedBox(height: 12),
                  Text(
                    'by ${news.author} • ${_formatDate(news.date)}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 12),
                  Text(news.summary),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.thumb_up_alt_outlined),
                        onPressed: () {
                          context.read<NewsPreviewBloc>().add(LikePressed());
                        },
                      ),
                      Text('${news.likes}'),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.thumb_down_alt_outlined),
                        onPressed: () {
                          context.read<NewsPreviewBloc>().add(DislikePressed());
                        },
                      ),
                      Text('${news.dislikes}'),
                    ],
                  ),

                  if (state.error != null)
                    Text(state.error!, style: const TextStyle(color: Colors.red)),

                  const Divider(height: 32),
                  const Text('Comments', style: TextStyle(fontWeight: FontWeight.bold)),

                  const SizedBox(height: 12),
                  if (news.comments.isEmpty)
                    const Text("No comments yet.")
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: news.comments.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (_, index) {
                        final comment = news.comments[index];
                        return ListTile(
                          title: Text(comment['text']),
                          subtitle: Text('— ${comment['user']}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () {
                              context.read<NewsPreviewBloc>().add(DeleteComment(index));
                            },
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 20),
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: "Add a comment",
                      border: OutlineInputBorder(),
                    ),
                    minLines: 1,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final text = _controller.text.trim();
                        if (text.isNotEmpty) {
                          context.read<NewsPreviewBloc>().add(SubmitComment(text));
                          _controller.clear();
                        }
                      },
                      icon: const Icon(Icons.send),
                      label: const Text("Post"),
                    ),
                  ),
                ],
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
