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
}
