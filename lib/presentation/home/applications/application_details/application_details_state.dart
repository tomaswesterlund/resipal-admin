import 'package:equatable/equatable.dart';
import 'package:resipal_core/lib.dart';

abstract class ApplicationDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends ApplicationDetailsState {}

class LoadingState extends ApplicationDetailsState {}

class LoadedState extends ApplicationDetailsState {
  final ApplicationEntity application;

  LoadedState(this.application);

  @override
  List<Object?> get props => [application];
}

class ErrorState extends ApplicationDetailsState {}
