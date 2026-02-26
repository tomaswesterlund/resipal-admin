import 'package:equatable/equatable.dart';
import 'register_contract_form_state.dart';

abstract class RegisterContractState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FormEditingState extends RegisterContractState {
  final RegisterContractFormState formState;
  FormEditingState(this.formState);

  @override
  List<Object?> get props => [formState];
}

class FormSubmittingState extends RegisterContractState {}

class FormSubmittedSuccessfullyState extends RegisterContractState {}

class ErrorState extends RegisterContractState {}
