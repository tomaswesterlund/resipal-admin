import 'package:equatable/equatable.dart';
import 'package:resipal_core/lib.dart';

 abstract class ConfirmPaymentState extends Equatable {
  @override
  List<Object?> get props => [];
 }

class InitialState extends ConfirmPaymentState {}

class LoadingState extends ConfirmPaymentState {}

class LoadedState extends ConfirmPaymentState {
  final PaymentEntity payment;

  LoadedState(this.payment);

  @override
  List<Object?> get props => [payment];
}

class SubmittingState extends ConfirmPaymentState {}

class SubmittedSuccessfullyState extends ConfirmPaymentState {}

class ErrorState extends ConfirmPaymentState {}
