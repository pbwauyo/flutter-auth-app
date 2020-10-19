part of 'signup_method_cubit.dart';

abstract class SignupMethodState extends Equatable {
  const SignupMethodState();

  @override
  List<Object> get props => [];
}

class SignupMethodInitial extends SignupMethodState {}

class SignupMethodEmail extends SignupMethodState {}

class SignupMethodPhone extends SignupMethodState {}
