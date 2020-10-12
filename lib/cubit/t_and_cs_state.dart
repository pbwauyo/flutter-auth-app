part of 't_and_cs_cubit.dart';

abstract class TAndCsState extends Equatable {
  const TAndCsState();

  @override
  List<Object> get props => [];
}

class TAndCsUnchecked extends TAndCsState {}

class TAndCsChecked extends TAndCsState {}

