import 'package:equatable/equatable.dart';
import 'package:resipal_core/domain/entities/contract_entity.dart';

abstract class ContractListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends ContractListState {}

class LoadingState extends ContractListState {}

class LoadedState extends ContractListState {
  final List<ContractEntity> contracts;
  LoadedState(this.contracts);

  @override
  List<Object?> get props => [contracts];
}

class EmptyState extends ContractListState {}

class ErrorState extends ContractListState {
  final String message;
  ErrorState(this.message);

  @override
  List<Object?> get props => [message];
}