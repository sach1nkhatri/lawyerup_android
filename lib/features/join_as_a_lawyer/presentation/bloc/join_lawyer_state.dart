abstract class JoinLawyerState {}

class JoinLawyerInitial extends JoinLawyerState {}

class JoinLawyerLoading extends JoinLawyerState {}

class JoinLawyerSuccess extends JoinLawyerState {}

class JoinLawyerFailure extends JoinLawyerState {
  final String message;

  JoinLawyerFailure(this.message);
}
