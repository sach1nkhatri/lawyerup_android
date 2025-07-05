import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_bookings.dart';
import '../../domain/usecases/delete_booking.dart';
import '../../domain/usecases/update_booking_status.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final GetBookings getBookings;
  final DeleteBooking deleteBooking;
  final UpdateBookingStatus updateBookingStatus;

  BookingBloc({
    required this.getBookings,
    required this.deleteBooking,
    required this.updateBookingStatus,
  }) : super(BookingInitial()) {
    on<LoadBookings>(_onLoad);
    on<CancelBooking>(_onCancel);
    on<ApproveBooking>(_onApprove);
    on<CompleteBooking>(_onComplete);
  }

  Future<void> _onLoad(LoadBookings event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final bookings = await getBookings(userId: event.userId, role: event.role);
      emit(BookingLoaded(bookings));
    } catch (e) {
      emit(BookingError("Failed to load bookings"));
    }
  }

  Future<void> _onCancel(CancelBooking event, Emitter<BookingState> emit) async {
    await deleteBooking(event.bookingId);
    add(LoadBookings(userId: event.userId, role: event.role)); // reload
  }

  Future<void> _onApprove(ApproveBooking event, Emitter<BookingState> emit) async {
    await updateBookingStatus(event.bookingId, "approved");
    add(LoadBookings(userId: event.userId, role: event.role));
  }

  Future<void> _onComplete(CompleteBooking event, Emitter<BookingState> emit) async {
    await updateBookingStatus(event.bookingId, "completed");
    add(LoadBookings(userId: event.userId, role: event.role));
  }
}