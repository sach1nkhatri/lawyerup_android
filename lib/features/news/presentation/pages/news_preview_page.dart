import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../app/constant/api_endpoints.dart';


class NewsPreviewPage extends StatefulWidget {
  final String newsId;

  const NewsPreviewPage({super.key, required this.newsId});

  @override
  State<NewsPreviewPage> createState() => _NewsPreviewPageState();
}

class _NewsPreviewPageState extends State<NewsPreviewPage> {
  Map<String, dynamic>? news;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchNewsDetails();
  }

  Future<void> _fetchNewsDetails() async {
    final res = await http.get(Uri.parse('${ApiEndpoints.getAllNews}/${widget.newsId}'));
    if (res.statusCode == 200) {
      setState(() {
        news = json.decode(res.body);
      });
    }
  }

  Future<void> _submitComment() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final res = await http.post(
      Uri.parse(ApiEndpoints.commentNews(widget.newsId)),
      headers: {
        'Authorization': 'Bearer YOUR_TOKEN_HERE', // Replace this
        'Content-Type': 'application/json'
      },
      body: json.encode({ 'text': text }),
    );

    if (res.statusCode == 200) {
      _controller.clear();
      _fetchNewsDetails(); // reload updated comments
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to post comment')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (news == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text(news!['title'])),
      body: Column(
        children: [
          Image.network(news!['image']),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(news!['summary']),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: news!['comments'].length,
              itemBuilder: (_, i) {
                final comment = news!['comments'][i];
                return ListTile(
                  leading: const Icon(Icons.comment),
                  title: Text(comment['user']),
                  subtitle: Text(comment['text']),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: "Add a comment"),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _submitComment,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
