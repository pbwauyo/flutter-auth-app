import 'package:auth_app/repos/test_invitation_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'test_login_state.dart';

class TestLoginCubit extends Cubit<TestLoginState> {
  final testInvitationRepo = TestInvitationRepo();
  TestLoginCubit() : super(TestLoginInitial());

  Future<void> loginTester({@required String email, @required String invitationCode}) async{
    try{
      emit(TestLoginInProgress());
      await testInvitationRepo.loginTester(email: email, invitationCode: invitationCode);
      emit(TestLoginInitial());
    }catch(error){
      emit(TestLoginInitial());
      throw(error);
    }
    
  }
}
