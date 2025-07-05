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

  @override
  List<Object?> get props => [role, userId];
}

class CancelBooking extends BookingEvent {
  final String bookingId;
  final String role;
  final String userId;

  const CancelBooking({
    required this.bookingId,
    required this.role,
    required this.userId,
  });

  @override
  List<Object?> get props => [bookingId, role, userId];
}

class ApproveBooking extends BookingEvent {
  final String bookingId;
  final String role;
  final String userId;

  const ApproveBooking({
    required this.bookingId,
    required this.role,
    required this.userId,
  });

  @override
  List<Object?> get props => [bookingId, role, userId];
}

class CompleteBooking extends BookingEvent {
  final String bookingId;
  final String role;
  final String userId;

  const CompleteBooking({
    required this.bookingId,
    required this.role,
    required this.userId,
  });

  @override
  List<Object?> get props => [bookingId, role, userId];
}
