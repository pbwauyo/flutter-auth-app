import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'signup_method_state.dart';

class SignupMethodCubit extends Cubit<SignupMethodState> {
  SignupMethodCubit() : super(SignupMethodInitial());

  emitEmailSignUp(){
    emit(SignupMethodEmail());
  }

  emitPhoneSignUp(){
    emit(SignupMethodPhone());
  }
}
