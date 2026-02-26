import 'package:equatable/equatable.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';

abstract class PropertyListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends PropertyListState {}

class LoadingState extends PropertyListState {}

class LoadedState extends PropertyListState {
  final List<PropertyEntity> properties;
  LoadedState(this.properties);

  @override
  List<Object?> get props => [properties];
}

class EmptyState extends PropertyListState {}

class ErrorState extends PropertyListState {}
