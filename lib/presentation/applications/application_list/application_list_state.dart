import 'package:equatable/equatable.dart';
import 'package:resipal_core/lib.dart';

abstract class ApplicationListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends ApplicationListState {}

class LoadingState extends ApplicationListState {}

class LoadedState extends ApplicationListState {
  final List<ApplicationEntity> applications;

  LoadedState(this.applications);

  @override
  List<Object?> get props => [applications];
}

class EmptyState extends ApplicationListState {}

class ErrorState extends ApplicationListState {}
