import '../../domain/entities/news.dart';

abstract class NewsPreviewEvent {}

class InitPreview extends NewsPreviewEvent {
  final News news;
  InitPreview(this.news);
}

class SubmitComment extends NewsPreviewEvent {
  final String text;
  SubmitComment(this.text);
}

class DeleteComment extends NewsPreviewEvent {
  final int index;
  DeleteComment(this.index);
}

class LikePressed extends NewsPreviewEvent {}

class DislikePressed extends NewsPreviewEvent {}
