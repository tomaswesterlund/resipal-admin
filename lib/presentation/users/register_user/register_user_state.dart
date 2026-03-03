import 'package:equatable/equatable.dart';
import 'package:resipal_admin/presentation/users/register_user/register_user_form_state.dart';

class RegisterUserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends RegisterUserState {}

class FormEditingState extends RegisterUserState {
  final RegisterUserFormState formState;

  FormEditingState(this.formState);

  @override
  List<Object?> get props => [formState];
}

class FormSubmittingState extends RegisterUserState {}

class FormSubmittedSuccessfullyState extends RegisterUserState {}

class ErrorState extends RegisterUserState {}
