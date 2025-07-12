import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/join_lawyer_repository.dart';
import 'join_lawyer_event.dart';
import 'join_lawyer_state.dart';


class JoinLawyerBloc extends Bloc<JoinLawyerEvent, JoinLawyerState> {
  final JoinLawyerRepository repository;

  JoinLawyerBloc({required this.repository}) : super(JoinLawyerInitial()) {
    on<SubmitLawyerApplication>((event, emit) async {
      emit(JoinLawyerLoading());

      try {
        await repository.submitApplication(event.application, event.token);
        emit(JoinLawyerSuccess());
      } catch (e) {
        emit(JoinLawyerFailure(e.toString()));
      }
    });
  }
}
