import 'package:equatable/equatable.dart';
import 'package:resipal_core/domain/entities/community/community_entity.dart';
import 'package:resipal_core/domain/entities/user_entity.dart';

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
