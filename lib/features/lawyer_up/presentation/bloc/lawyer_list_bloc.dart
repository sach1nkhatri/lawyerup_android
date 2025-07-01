import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_all_lawyers.dart';
import 'lawyer_list_event.dart';
import 'lawyer_list_state.dart';

class LawyerListBloc extends Bloc<LawyerListEvent, LawyerListState> {
  final GetAllLawyers getAllLawyersUseCase;

  LawyerListBloc(this.getAllLawyersUseCase) : super(LawyerListInitial()) {
    on<FetchAllLawyersEvent>((event, emit) async {
      emit(LawyerListLoading());

      try {
        final lawyers = await getAllLawyersUseCase();
        emit(LawyerListLoaded(lawyers: lawyers));
      } catch (e) {
        emit(LawyerListError(message: e.toString()));
      }
    });
  }
}
