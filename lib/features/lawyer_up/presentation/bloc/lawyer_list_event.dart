import 'package:equatable/equatable.dart';

abstract class LawyerListEvent extends Equatable {
  const LawyerListEvent();

  @override
  List<Object> get props => [];
}

// 🔍 Event to fetch all lawyers
class FetchAllLawyersEvent extends LawyerListEvent {}
