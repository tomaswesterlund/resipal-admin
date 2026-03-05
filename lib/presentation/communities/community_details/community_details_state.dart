import 'package:equatable/equatable.dart';
import 'package:resipal_core/lib.dart';

abstract class CommunityDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends CommunityDetailsState {}

class LoadingState extends CommunityDetailsState {}

class LoadedState extends CommunityDetailsState {
  final CommunityEntity community;

  LoadedState(this.community);

  @override
  List<Object?> get props => [community];
}

class ErrorState extends CommunityDetailsState {}
