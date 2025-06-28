import '../../domain/entities/news.dart';

class NewsModel extends News {
  final List<dynamic> comments;

  NewsModel({
    required super.id,
    required super.title,
    required super.summary,
    required super.image,
    required super.likes,
    required super.dislikes,
    required super.author,
    required super.date,
    required this.comments,
  }) : super(comments: comments);

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['_id'],
      title: json['title'],
      summary: json['summary'],
      image: json['image'],
      likes: json['likes'],
      dislikes: json['dislikes'],
      author: json['author'] ?? 'Unknown',
      date: json['date'] ?? '',
      comments: json['comments'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'summary': summary,
      'image': image,
      'likes': likes,
      'dislikes': dislikes,
      'author': author,
      'date': date,
      'comments': comments,
    };
  }
}
