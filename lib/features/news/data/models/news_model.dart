import '../../domain/entities/news.dart';

class NewsModel extends News {
  NewsModel({
    required super.id,
    required super.title,
    required super.summary,
    required super.date,
    required super.image,
    required super.likes,
    required super.dislikes,
    required super.comments,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['_id'],
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      date: json['date'] ?? '',
      image: json['image'] ?? '',
      likes: json['likes'] ?? 0,
      dislikes: json['dislikes'] ?? 0,
      comments: (json['comments'] as List<dynamic>?)
          ?.map((c) => c['text'] as String)
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'title': title,
    'summary': summary,
    'date': date,
    'image': image,
    'likes': likes,
    'dislikes': dislikes,
    'comments': comments.map((e) => {'text': e}).toList(),
  };
}
