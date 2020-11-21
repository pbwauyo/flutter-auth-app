import 'package:auth_app/models/tester.dart';
import 'package:auth_app/repos/test_invitation_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'test_signup_state.dart';

class TestSignupCubit extends Cubit<TestSignupState> {
  TestSignupCubit() : super(TestSignupInitial());
  final _testInvitationRepo = TestInvitationRepo();

  Future<void> startSignUp(Tester tester) async{
    try{
      emit(TestSignupInProgress());
      await _testInvitationRepo.saveTester(tester);
      emit(TestSignupInitial());
    }
    catch(error){
      emit(TestSignupInitial());
      throw(error);
    }
    
  }
}
