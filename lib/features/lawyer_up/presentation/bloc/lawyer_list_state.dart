import '../../domain/entities/lawyer.dart';

abstract class LawyerListState {}

class LawyerListInitial extends LawyerListState {}

class LawyerListLoading extends LawyerListState {}

class LawyerListLoaded extends LawyerListState {
  final List<Lawyer> lawyers;

  LawyerListLoaded(this.lawyers);
}

class LawyerListError extends LawyerListState {
  final String message;

  LawyerListError(this.message);
}
