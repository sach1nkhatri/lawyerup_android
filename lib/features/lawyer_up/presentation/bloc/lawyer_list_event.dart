import 'package:equatable/equatable.dart';

abstract class LawyerListEvent extends Equatable {
  const LawyerListEvent();

  @override
  List<Object> get props => [];
}

class FetchAllLawyers extends LawyerListEvent {}
