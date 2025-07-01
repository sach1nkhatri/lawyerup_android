import 'package:equatable/equatable.dart';
import '../../domain/entities/lawyer.dart';

abstract class LawyerListState extends Equatable {
  const LawyerListState();

  @override
  List<Object> get props => [];
}

// Initial State
class LawyerListInitial extends LawyerListState {}

//  Loading
class LawyerListLoading extends LawyerListState {}

//  Loaded
class LawyerListLoaded extends LawyerListState {
  final List<Lawyer> lawyers;

  const LawyerListLoaded({required this.lawyers});

  @override
  List<Object> get props => [lawyers];
}

//  Error
class LawyerListError extends LawyerListState {
  final String message;

  const LawyerListError({required this.message});

  @override
  List<Object> get props => [message];
}
