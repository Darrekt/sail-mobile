part of 'pictures_bloc.dart';

abstract class PicturesState extends Equatable {
  const PicturesState();
  
  @override
  List<Object> get props => [];
}

class PicturesInitial extends PicturesState {}
