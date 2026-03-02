import 'package:equatable/equatable.dart';
import 'package:resipal_core/lib.dart';

abstract class PropertyDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingState extends PropertyDetailsState {}

class LoadedState extends PropertyDetailsState {
  final PropertyEntity property;
  LoadedState(this.property);

  @override
  List<Object?> get props => [property];
}

class ErrorState extends PropertyDetailsState {}
