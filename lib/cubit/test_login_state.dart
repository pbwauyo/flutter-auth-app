part of 'test_login_cubit.dart';

abstract class TestLoginState extends Equatable {
  const TestLoginState();

  @override
  List<Object> get props => [];
}

class TestLoginInitial extends TestLoginState {}

class TestLoginInProgress extends TestLoginState {}

class TestLoginDone extends TestLoginState {}
