import 'package:auth_app/models/app_user.dart';
import 'package:auth_app/repos/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());
  final _authRepo = AuthRepo();

  Future<void> startSignup(String password, AppUser appUser) async{
    try{
      emit(SignupInProgress());
      await _authRepo.signUpWithFirebase(appUser, password);
      emit(SignupSuccess());
    }catch(error){
      emit(SignupError(error)); 
    }finally{
      emit(SignupInitial()); //reset state to initial
    }
  }

}
