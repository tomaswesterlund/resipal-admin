import 'package:equatable/equatable.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';

abstract class PaymentListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends PaymentListState {}

class LoadingState extends PaymentListState {}

class LoadedState extends PaymentListState {
  final List<PaymentEntity> payments;
  final List<FilterSelectorItem> filterItems;
  final FilterSelectorItem selectedFilter;

  LoadedState(this.payments, this.filterItems, this.selectedFilter);

  @override
  List<Object?> get props => [payments, filterItems, selectedFilter];
}

class EmptyState extends PaymentListState {}

class ErrorState extends PaymentListState {}
