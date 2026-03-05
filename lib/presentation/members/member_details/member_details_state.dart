import 'package:equatable/equatable.dart';
import 'package:resipal_core/lib.dart';

abstract class MemberDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends MemberDetailsState {}

class LoadingState extends MemberDetailsState {}

class LoadedState extends MemberDetailsState {
  final MemberEntity member;

  LoadedState(this.member);

  @override
  List<Object?> get props => [member];
}

class ErrorState extends MemberDetailsState {}