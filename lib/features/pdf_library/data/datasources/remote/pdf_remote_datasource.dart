import '../../../../../core/network/dio_client.dart';
import '../../models/pdf_model.dart';

class PdfRemoteDataSource {
  final DioClient dioClient;

  PdfRemoteDataSource(this.dioClient);

  Future<List<PdfModel>> getAllPdfs() async {
    final response = await dioClient.dio.get('/pdfs');
    final data = response.data as List;

    return data.map((e) => PdfModel.fromJson(e)).toList();
  }
}
