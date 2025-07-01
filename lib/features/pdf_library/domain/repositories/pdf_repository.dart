import '../entities/pdf_entity.dart';

abstract class PdfRepository {
  Future<List<PdfEntity>> getAllPdfs();
}
