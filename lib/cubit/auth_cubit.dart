import 'package:auth_app/repos/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final _authRepo = AuthRepo();

  bool checkLoggedInUser(){
    if(_authRepo.isUserLoggedIn()){
      emit(AuthLoggedIn());
      return true;
    }
    else {
      emit(AuthInitial());
      return false;
    }
  }
}
