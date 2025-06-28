class News {
  final String id;
  final String title;
  final String summary;
  final String date;
  final String image;
  final int likes;
  final int dislikes;
  final List<String> comments;

  News({
    required this.id,
    required this.title,
    required this.summary,
    required this.date,
    required this.image,
    required this.likes,
    required this.dislikes,
    required this.comments,
  });
}
