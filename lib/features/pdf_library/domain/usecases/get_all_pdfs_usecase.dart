import '../entities/pdf_entity.dart';
import '../repositories/pdf_repository.dart';

class GetAllPdfsUseCase {
  final PdfRepository repository;

  GetAllPdfsUseCase(this.repository);

  Future<List<PdfEntity>> call() async {
    return await repository.getAllPdfs();
  }
}
