import 'package:equatable/equatable.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class LoadBookings extends BookingEvent {
  final String role;
  final String userId;

  const LoadBookings({required this.role, required this.userId});
}

class CancelBooking extends BookingEvent {
  final String bookingId;

  const CancelBooking(this.bookingId);
}

class ApproveBooking extends BookingEvent {
  final String bookingId;

  const ApproveBooking(this.bookingId);
}

class CompleteBooking extends BookingEvent {
  final String bookingId;

  const CompleteBooking(this.bookingId);
}
