import 'package:equatable/equatable.dart';

abstract class PdfEvent extends Equatable {
  const PdfEvent();

  @override
  List<Object> get props => [];
}

class FetchPdfs extends PdfEvent {}
