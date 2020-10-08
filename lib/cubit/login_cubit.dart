import 'package:auth_app/models/app_user.dart';
import 'package:auth_app/repos/auth_repo.dart';
import 'package:auth_app/utils/pref_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

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
      return null;
    }
  }

  Future<Map<String, String>> startFacebookLogin() async{
    try{
      emit(LoginInProgress());
      final profile = await _authRepo.getProfileFromFacebook();
      emit(LoginSuccess());
      emit(LoginInitial());
      return profile;
    }catch(error){
      emit(LoginError(error));
      return null;
    }
  }

  Future<Map<String, String>> startTwitterLogin() async{
    try{
      emit(LoginInProgress());
      final profile = await _authRepo.getProfileFromTwitter();
      emit(LoginSuccess());
      emit(LoginInitial());
      return profile;
    }catch(error){
      emit(LoginError(error));
      return null;
    }
  }

  Future<Map<String, String>> startGoogleLogin() async{
    try{
      emit(LoginInProgress());
      final profile = await _authRepo.getProfileFromGoogle();
      emit(LoginSuccess());
      emit(LoginInitial());
      return profile;
    }catch(error){
      emit(LoginError(error));
      return null;
    }
  }

}
