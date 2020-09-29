part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginInProgress extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginError extends LoginState {
  final dynamic error;
  LoginError(this.error);

  @override
  List<Object> get props => [error];
}
