import '../../domain/entity/lawyer_application.dart';

abstract class JoinLawyerEvent {}

class SubmitLawyerApplication extends JoinLawyerEvent {
  final LawyerApplication application;
  final String token;

  SubmitLawyerApplication(this.application, this.token);
}
