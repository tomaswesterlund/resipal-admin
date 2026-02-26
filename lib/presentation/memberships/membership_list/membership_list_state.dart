import 'package:equatable/equatable.dart';
import 'package:resipal_core/lib.dart';

abstract class MembershipListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends MembershipListState {}

class LoadingState extends MembershipListState {}

class LoadedState extends MembershipListState {
  final List<MembershipEntity> members;
  LoadedState(this.members);

  @override
  List<Object?> get props => [members];
}

class EmptyState extends MembershipListState {}

class ErrorState extends MembershipListState {}