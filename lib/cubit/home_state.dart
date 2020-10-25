part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeCreateMoment extends HomeState {}

class HomePickCategory extends HomeState {}

class HomeMomentDetails extends HomeState {}



