import 'package:auth_app/models/app_user.dart';
import 'package:auth_app/repos/auth_repo.dart';
import 'package:auth_app/utils/pref_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  final _authRepo = AuthRepo();

  Future<AppUser> startFirebaseLogin(String email, String password) async{
    try{
      emit(LoginInProgress());
      await _authRepo.signInWithFirebase(email, password);
      emit(LoginSuccess());
      emit(LoginInitial());
      PrefManager.saveLoginType("EMAIL");
      return _authRepo.getCurrentUserDetails();
    }catch(error){
      emit(LoginError(error));
      throw(error);
    }
  }

  Future<AppUser> startFirebasePhoneLogin(String verificationId, String smsCode) async{
    try{
      emit(LoginInProgress());
      await _authRepo.signInWithPhone(verificationId: verificationId, smsCode: smsCode);
      emit(LoginSuccess());
      emit(LoginInitial());
      PrefManager.saveLoginType("PHONE");
      return _authRepo.getCurrentUserDetails();
    }catch(error){
      emit(LoginError(error));
      throw(error);
    }
  }

  Future<Map<String, String>> startFacebookLogin(BuildContext context) async{
    try{
      emit(LoginInProgress());
      final profile = await _authRepo.getProfileFromFacebook(context);
      emit(LoginSuccess());
      emit(LoginInitial());
      return profile;
    }catch(error){
      emit(LoginError(error));
      throw(error);
    }
  }

  Future<Map<String, String>> startTwitterLogin(BuildContext context) async{
    try{
      emit(LoginInProgress());
      final profile = await _authRepo.getProfileFromTwitter(context);
      emit(LoginSuccess());
      emit(LoginInitial());
      return profile;
    }catch(error){
      emit(LoginError(error));
      throw(error);
    }
  }

  Future<Map<String, String>> startGoogleLogin(BuildContext context) async{
    try{
      emit(LoginInProgress());
      final profile = await _authRepo.getProfileFromGoogle(context);
      emit(LoginSuccess());
      emit(LoginInitial());
      return profile;
    }catch(error){
      emit(LoginError(error));
      throw(error);
    }
  }

  Future<Map<String, String>> startAppleLogin(BuildContext context) async{
    try{
      emit(LoginInProgress());
      final profile = await _authRepo.getProfileFromApple(context);
      emit(LoginSuccess());
      emit(LoginInitial());
      return profile;
    }catch(error){
      emit(LoginError(error));
      throw(error);
    }
  }

}
