import 'package:equatable/equatable.dart';
import 'package:resipal_admin/presentation/onboarding/community_registration/onboarding_community_registration_form_state.dart';
import 'package:resipal_core/domain/entities/community/community_entity.dart';
import 'package:resipal_core/domain/entities/user_entity.dart';

abstract class OnboardingCommunityRegistrationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends OnboardingCommunityRegistrationState {}

class FormEditingState extends OnboardingCommunityRegistrationState {
  final OnboardingCommunityRegistrationFormState formstate;

  FormEditingState(this.formstate);

  @override
  List<Object?> get props => [formstate];
}

class FormSubmittingState extends OnboardingCommunityRegistrationState {}

class FormSubmittedSuccessfully extends OnboardingCommunityRegistrationState {
  final CommunityEntity community;
  final UserEntity user;

  FormSubmittedSuccessfully({required this.community, required this.user});
}

class ErrorState extends OnboardingCommunityRegistrationState {}
