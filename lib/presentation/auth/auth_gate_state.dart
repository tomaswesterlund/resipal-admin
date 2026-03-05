import 'package:equatable/equatable.dart';
import 'package:resipal_core/lib.dart';

abstract class AuthGateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends AuthGateState {}

class LoadingState extends AuthGateState {}

class UserNotSignedIn extends AuthGateState {}

class UserNotOnboarded extends AuthGateState {}

class CommunityNotOnboarded extends AuthGateState {}

class UserHasNoAdminMembership extends AuthGateState {}

class UserIsNotAdmin extends AuthGateState {}

class UserSignedIn extends AuthGateState {
  final CommunityEntity community;
  final UserEntity user;

  UserSignedIn(this.community, this.user);
}

class ErrorState extends AuthGateState {}
