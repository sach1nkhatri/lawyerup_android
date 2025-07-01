import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_all_pdfs_usecase.dart';
import 'pdf_event.dart';
import 'pdf_state.dart';


class PdfBloc extends Bloc<PdfEvent, PdfState> {
  final GetAllPdfsUseCase getAllPdfs;

  PdfBloc(this.getAllPdfs) : super(PdfInitial()) {
    on<FetchPdfs>(_onFetchPdfs);
  }

  Future<void> _onFetchPdfs(FetchPdfs event, Emitter<PdfState> emit) async {
    emit(PdfLoading());
    try {
      final pdfs = await getAllPdfs();
      emit(PdfLoaded(pdfs));
    } catch (e) {
      emit(PdfError(e.toString()));
    }
  }
}
