part of 'signup_cubit.dart';

abstract class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

class SignupInitial extends SignupState {}

class SignupInProgress extends SignupState {}

class SignupSuccess extends SignupState {}

class SignupError extends SignupState {
  final dynamic error;

  SignupError(this.error);

  @override
  List<Object> get props => [error];
}
