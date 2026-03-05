import 'package:equatable/equatable.dart';
import 'package:resipal_core/lib.dart';

abstract class HomeOverviewState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends HomeOverviewState {}

class LoadingState extends HomeOverviewState {}

class LoadedState extends HomeOverviewState {
  final CommunityEntity community;
  final UserEntity user;

  LoadedState({required this.community, required this.user});

  @override
  List<Object?> get props => [community, user];
}

class EmptyState extends HomeOverviewState {}

class ErrorState extends HomeOverviewState {}
