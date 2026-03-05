import 'package:equatable/equatable.dart';
import 'register_application_form_state.dart';

abstract class RegisterApplicationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends RegisterApplicationState {}

class FormEditingState extends RegisterApplicationState {
  final RegisterApplicationFormState formState;

  FormEditingState(this.formState);

  @override
  List<Object?> get props => [formState];
}

class FormSubmittingState extends RegisterApplicationState {}

class FormSubmittedSuccessfullyState extends RegisterApplicationState {}

class ErrorState extends RegisterApplicationState {}
