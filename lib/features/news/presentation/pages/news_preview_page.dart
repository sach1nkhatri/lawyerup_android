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
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    final response =
    await http.get(Uri.parse('${ApiEndpoints.getAllNews}/${widget.newsId}'));
    if (response.statusCode == 200) {
      setState(() {
        news = json.decode(response.body);
      });
    }
  }

  Future<void> _postComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final res = await http.post(
      Uri.parse(ApiEndpoints.commentNews(widget.newsId)),
      headers: {
        'Authorization': 'Bearer YOUR_TOKEN_HERE', // Replace later
        'Content-Type': 'application/json',
      },
      body: json.encode({'text': text}),
    );

    if (res.statusCode == 200) {
      _commentController.clear();
      _fetchNews(); // reload comments
    }
  }

  Future<void> _like() async {
    await http.post(
      Uri.parse(ApiEndpoints.likeNews(widget.newsId)),
      body: json.encode({"userId": "demoUserId"}), // Replace with real userId
      headers: {'Content-Type': 'application/json'},
    );
    _fetchNews();
  }

  Future<void> _dislike() async {
    await http.post(
      Uri.parse(ApiEndpoints.dislikeNews(widget.newsId)),
      body: json.encode({"userId": "demoUserId"}), // Replace with real userId
      headers: {'Content-Type': 'application/json'},
    );
    _fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    if (news == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2B3A),
        title: Text(news!['title']),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            news!['date'] ?? '',
            style: const TextStyle(
              fontFamily: 'Lora',
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            news!['title'],
            style: const TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "By Post Report",
            style: TextStyle(
              fontFamily: 'Lora',
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            news!['summary'],
            style: const TextStyle(
              fontFamily: 'Lora',
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.thumb_up_alt_outlined),
                onPressed: _like,
              ),
              Text('${news!['likes']}'),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.thumb_down_alt_outlined),
                onPressed: _dislike,
              ),
              Text('${news!['dislikes']}'),
              const Spacer(),
              const Icon(Icons.comment),
              const SizedBox(width: 4),
              Text('${news!['comments'].length}'),
            ],
          ),
          const Divider(height: 32),
          const Text("Comments", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...news!['comments'].map<Widget>((c) {
            return ListTile(
              leading: const Icon(Icons.comment),
              title: Text(c['user']),
              subtitle: Text(c['text']),
            );
          }).toList(),
          const SizedBox(height: 12),
          TextField(
            controller: _commentController,
            decoration: InputDecoration(
              hintText: "Add a comment...",
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: _postComment,
              ),
            ),
          )
        ]),
      ),
    );
  }
}
