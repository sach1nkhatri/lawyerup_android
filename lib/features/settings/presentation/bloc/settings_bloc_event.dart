import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettingsUser extends SettingsEvent {}

class SaveSettingsUserProfile extends SettingsEvent {
  final String contactNumber;
  final String state;
  final String city;
  final String address;

  const SaveSettingsUserProfile({
    required this.contactNumber,
    required this.state,
    required this.city,
    required this.address,
  });

  @override
  List<Object?> get props => [contactNumber, state, city, address];
}
