import 'package:auth_app/repos/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  checkLoggedInUser(){
    if(AuthRepo.isUserLoggedIn()){
      emit(AuthLoggedIn());
    }
    else {
      emit(AuthInitial());
    }
  }
}
