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
  final List<FilterSelectorItem> selectorItems;
  final FilterSelectorItem selector;

  LoadedState(this.payments, this.selectorItems, this.selector);

  @override
  List<Object?> get props => [payments, selectorItems, selector];
}

class EmptyState extends PaymentListState {}

class ErrorState extends PaymentListState {}
