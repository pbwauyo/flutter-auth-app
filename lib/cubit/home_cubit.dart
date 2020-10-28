import 'package:auth_app/models/memory.dart';
import 'package:auth_app/models/moment.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  goToInitial(){
    emit(HomeInitial());
  }

  goToCreateMomentScreen(){
    emit(HomeCreateMoment());
  }

  goToPickCategoryScreen(){
    emit(HomePickCategory());
  }

  goToAddMomentDetailsScreen({Moment moment}){
    if(moment != null){
      emit(HomeAddMomentDetails(moment: moment));
    }else {
      emit(HomeAddMomentDetails());
    }   
  }
  
  goToMomentDetailsScreen(Moment moment){
    emit(HomeMomentDetails(moment));
  }

  goToMemoryDetailsScreen(Memory memory){
    emit(HomeMemoryDetails(memory));
  }
}
