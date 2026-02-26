import 'package:equatable/equatable.dart';
import 'register_payment_form_state.dart';

abstract class RegisterPaymentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends RegisterPaymentState {}

class NoResidentsFound extends RegisterPaymentState {}

class FormEditingState extends RegisterPaymentState {

  final RegisterPaymentFormState formState;

  FormEditingState(this.formState);

  @override
  List<Object?> get props => [formState];
}

class FormSubmittingState extends RegisterPaymentState {}

class FormSubmittedSuccessfullyState extends RegisterPaymentState {}

class ErrorState extends RegisterPaymentState {}
