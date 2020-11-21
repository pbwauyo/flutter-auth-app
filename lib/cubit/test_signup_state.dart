part of 'test_signup_cubit.dart';

abstract class TestSignupState extends Equatable {
  const TestSignupState();

  @override
  List<Object> get props => [];
}

class TestSignupInitial extends TestSignupState {}

class TestSignupInProgress extends TestSignupState {}

class TestSignupDone extends TestSignupState {}
