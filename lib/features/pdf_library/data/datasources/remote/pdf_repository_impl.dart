import '../../../domain/entities/pdf_entity.dart';
import '../../../domain/repositories/pdf_repository.dart';
import 'pdf_remote_datasource.dart';

class PdfRepositoryImpl implements PdfRepository {
  final PdfRemoteDataSource remoteDataSource;

  PdfRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<PdfEntity>> getAllPdfs() async {
    final models = await remoteDataSource.getAllPdfs();
    return models;
  }
}
