import 'package:equatable/equatable.dart';
import 'package:resipal_admin/presentation/onboarding/user_registration/onboarding_user_registration_form_state.dart';

abstract class OnboardingUserRegistrationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends OnboardingUserRegistrationState {}

class FormEditingState extends OnboardingUserRegistrationState {
  final OnboardingUserRegistrationFormState formstate;

  FormEditingState(this.formstate);

  @override
  List<Object?> get props => [formstate];
}

class FormSubmittingState extends OnboardingUserRegistrationState {}

class FormSubmittedSuccessfully extends OnboardingUserRegistrationState {}

class ErrorState extends OnboardingUserRegistrationState {}
