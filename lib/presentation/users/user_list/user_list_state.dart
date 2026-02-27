import 'package:equatable/equatable.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';

abstract class UserListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends UserListState {}

class LoadingState extends UserListState {}

class LoadedState extends UserListState {
  final List<MembershipEntity> users;
  final List<FilterSelectorItem> userFilterItems;
  final FilterSelectorItem selectedUserFilter;
  final List<FilterSelectorItem> residentFilterItems;
  final FilterSelectorItem selectedResidentFilter;

  LoadedState({
    required this.users,
    required this.userFilterItems,
    required this.selectedUserFilter,
    required this.residentFilterItems,
    required this.selectedResidentFilter,
  });

  @override
  List<Object?> get props => [users, userFilterItems, selectedUserFilter, residentFilterItems, selectedResidentFilter];
}

class EmptyState extends UserListState {}

class ErrorState extends UserListState {}
