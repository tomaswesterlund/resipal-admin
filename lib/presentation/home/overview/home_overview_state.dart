import 'package:equatable/equatable.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';

abstract class HomeOverviewState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends HomeOverviewState {}

class LoadingState extends HomeOverviewState {}

class LoadedState extends HomeOverviewState {
  final UserEntity user;
  final CommunityEntity community;

  LoadedState(this.user, this.community);

  @override
  List<Object?> get props => [community];
}

class EmptyState extends HomeOverviewState {}

class ErrorState extends HomeOverviewState {}
