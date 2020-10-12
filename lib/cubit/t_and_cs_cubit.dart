import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 't_and_cs_state.dart';

class TAndCsCubit extends Cubit<TAndCsState> {
  TAndCsCubit() : super(TAndCsUnchecked());

  toggleCheckBox(){
    if(state is TAndCsChecked){
      emit(TAndCsUnchecked());
    }else{
      emit(TAndCsChecked());
    }
  }
}
