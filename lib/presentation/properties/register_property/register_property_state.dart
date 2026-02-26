import 'package:equatable/equatable.dart';

import 'register_property_form_state.dart';

class RegisterPropertyState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends RegisterPropertyState {}

class FormEditingState extends RegisterPropertyState {
  final RegisterPropertyFormState formState;

  FormEditingState(this.formState);

  @override
  List<Object?> get props => [formState];
}

class FormSubmittingState extends RegisterPropertyState {}

class FormSubmittedSuccessfullyState extends RegisterPropertyState {}

class NoContractsFound extends RegisterPropertyState {}

class ErrorState extends RegisterPropertyState {}
