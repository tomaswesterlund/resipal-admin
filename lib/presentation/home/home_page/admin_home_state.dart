import 'package:equatable/equatable.dart';
import 'package:resipal_core/lib.dart';

abstract class AdminHomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends AdminHomeState {}

class LoadingState extends AdminHomeState {}

class LoadedState extends AdminHomeState {
  final CommunityEntity community;

  LoadedState(this.community);

  @override
  List<Object?> get props => [community];
}

class EmptyState extends AdminHomeState {}

class ErrorState extends AdminHomeState {}
