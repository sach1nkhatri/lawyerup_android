import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_all_lawyers.dart';
import 'lawyer_list_event.dart';
import 'lawyer_list_state.dart';

class LawyerListBloc extends Bloc<LawyerListEvent, LawyerListState> {
  final GetAllLawyers getAllLawyers;

  LawyerListBloc(this.getAllLawyers) : super(LawyerListInitial()) {
    on<FetchAllLawyers>(_onFetchAllLawyers);
  }

  Future<void> _onFetchAllLawyers(
      FetchAllLawyers event, Emitter<LawyerListState> emit) async {
    emit(LawyerListLoading());
    try {
      final lawyers = await getAllLawyers(); // usecase
      emit(LawyerListLoaded(lawyers));
    } catch (e) {
      emit(LawyerListError(e.toString()));
    }
  }
}

