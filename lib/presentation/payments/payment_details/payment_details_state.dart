import 'package:equatable/equatable.dart';
import 'package:resipal_core/lib.dart';

abstract class PaymentDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends PaymentDetailsState {}

class LoadingState extends PaymentDetailsState {}

class LoadedState extends PaymentDetailsState {
  final PaymentEntity payment;

  LoadedState(this.payment);

  @override
  List<Object?> get props => [payment];
}

class ErrorState extends PaymentDetailsState {}
