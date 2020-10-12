import 'package:auth_app/models/app_user.dart';
import 'package:auth_app/repos/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());
  final _authRepo = AuthRepo();

  Future<bool> startSignup(String password, AppUser appUser) async{
    try{
      emit(SignupInProgress());
      await _authRepo.signUpWithFirebase(appUser, password);
      emit(SignupSuccess());
    }catch(error){
      emit(SignupError(error)); 
      return false;
    }finally{
      emit(SignupInitial()); //reset state to initial
    }
    return true;
  }

  Future<bool> startPhoneSignup({@required String verificationId, @required String smsCode}) async{
    try{
      emit(SignupInProgress());
      await _authRepo.signUpWIthPhone(verificationId: verificationId, smsCode: smsCode);
      emit(SignupSuccess());
    }catch(error){
      emit(SignupError(error)); 
      return false;
    }finally{
      emit(SignupInitial()); //reset state to initial
    }
    return true;
  }

}
