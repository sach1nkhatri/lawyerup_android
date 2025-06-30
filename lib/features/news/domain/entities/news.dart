class News {
  final String id;
  final String title;
  final String summary;
  final String image;
  final int likes;
  final int dislikes;
  final String author;
  final String date;
  final List<dynamic> comments;

  News({
    required this.id,
    required this.title,
    required this.summary,
    required this.image,
    required this.likes,
    required this.dislikes,
    required this.author,
    required this.date,
    required this.comments,
  });

  News copyWith({
    String? title,
    String? summary,
    String? image,
    int? likes,
    int? dislikes,
    String? author,
    String? date,
    List<dynamic>? comments,
  }) {
    return News(
      id: id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      image: image ?? this.image,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      author: author ?? this.author,
      date: date ?? this.date,
      comments: comments ?? this.comments,
    );
  }
}
