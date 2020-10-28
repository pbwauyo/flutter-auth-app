part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeCreateMoment extends HomeState {}

class HomePickCategory extends HomeState {}

class HomeAddMomentDetails extends HomeState {
  final Moment moment;
  HomeAddMomentDetails({this.moment});
}

class HomeMomentDetails extends HomeState {
  final Moment moment;
  HomeMomentDetails(this.moment);
}

class HomeMemoryDetails extends HomeState {
  final Memory memory;
  HomeMemoryDetails(this.memory);
}



