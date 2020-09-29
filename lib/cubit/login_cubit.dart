import 'package:auth_app/models/app_user.dart';
import 'package:auth_app/repos/auth_repo.dart';
import 'package:auth_app/utils/pref_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<AppUser> startFirebaseLogin(String email, String password) async{
    try{
      emit(LoginInProgress());
      await AuthRepo.signInWithFirebase(email, password);
      emit(LoginSuccess());
      emit(LoginInitial());
      PrefManager.saveLoginType("EMAIL");
      return AuthRepo.getCurrentUserDetails();
    }catch(error){
      emit(LoginError(error));
      return null;
    }
  }

  Future<AppUser> startFacebookLogin() async{
    try{
      emit(LoginInProgress());
      await AuthRepo.signInWithFacebook();
      emit(LoginSuccess());
      emit(LoginInitial());
      PrefManager.saveLoginType("FACEBOOK");
      return AuthRepo.getCurrentUserDetails();
    }catch(error){
      emit(LoginError(error));
      return null;
    }
  }

  Future<AppUser> startTwitterLogin() async{
    try{
      emit(LoginInProgress());
      await AuthRepo.signInWithTwitter();
      emit(LoginSuccess());
      emit(LoginInitial());
      PrefManager.saveLoginType("TWITTER");
      return AuthRepo.getCurrentUserDetails();
    }catch(error){
      emit(LoginError(error));
      return null;
    }
  }

  Future<AppUser> startGoogleLogin() async{
    try{
      emit(LoginInProgress());
      await AuthRepo.signInWithgoogle();
      emit(LoginSuccess());
      emit(LoginInitial());
      PrefManager.saveLoginType("GOOGLE");
      return AuthRepo.getCurrentUserDetails();
    }catch(error){
      emit(LoginError(error));
      return null;
    }
  }

}
