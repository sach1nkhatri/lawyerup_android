import 'package:equatable/equatable.dart';
import '../../domain/entities/pdf_entity.dart';

abstract class PdfState extends Equatable {
  const PdfState();

  @override
  List<Object?> get props => [];
}

class PdfInitial extends PdfState {}

class PdfLoading extends PdfState {}

class PdfLoaded extends PdfState {
  final List<PdfEntity> pdfs;

  const PdfLoaded(this.pdfs);

  @override
  List<Object?> get props => [pdfs];
}

class PdfError extends PdfState {
  final String message;

  const PdfError(this.message);

  @override
  List<Object?> get props => [message];
}
