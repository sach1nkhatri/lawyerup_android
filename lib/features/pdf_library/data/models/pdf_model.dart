import '../../domain/entities/pdf_entity.dart';

class PdfModel extends PdfEntity {
  PdfModel({
    required super.id,
    required super.title,
    required super.url,
  });

  factory PdfModel.fromJson(Map<String, dynamic> json) {
    return PdfModel(
      id: json['_id'],
      title: json['title'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'url': url,
    };
  }
}
