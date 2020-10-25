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

  goToMomentDetailsScreen(){
    emit(HomeMomentDetails());
  }

  goToInProgress(){
    emit(HomeInProgress());
  }
}
