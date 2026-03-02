import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:resipal_admin/admin_session_service.dart';
import 'package:resipal_admin/presentation/onboarding/community_registration/onboarding_community_registration_form_state.dart';
import 'package:resipal_admin/presentation/onboarding/community_registration/onboarding_community_registration_state.dart';
import 'package:resipal_core/lib.dart';

class OnboardingCommunityRegistrationCubit extends Cubit<OnboardingCommunityRegistrationState> {
  final LoggerService _logger = GetIt.I<LoggerService>();
  final AuthService _authService = GetIt.I<AuthService>();
  final AdminSessionService _sessionService = GetIt.I<AdminSessionService>();

  OnboardingCommunityRegistrationCubit() : super(InitialState());

  OnboardingCommunityRegistrationFormState _formState = OnboardingCommunityRegistrationFormState();

  void initialize() {
    emit(FormEditingState(_formState));
  }

  void onNameChanged(String value) {
    _formState = _formState.copyWith(name: value);
    emit(FormEditingState(_formState));
  }

  void onAddressChanged(String value) {
    _formState = _formState.copyWith(address: value);
    emit(FormEditingState(_formState));
  }

  void onDescriptionChanged(String value) {
    _formState = _formState.copyWith(location: value);
    emit(FormEditingState(_formState));
  }

  Future<void> submit() async {
    try {
      if (!_formState.canSubmit) return;

      emit(FormSubmittingState());

      final userId = _authService.getSignedInUserId();

      final communityId = await CreateCommunity().call(
        userId: userId,
        name: _formState.name,
        location: _formState.address,
        description: _formState.location,
        isAdmin: true,
        isUser: true,
        isSecurity: true,
      );

      await FetchCommunity().call(communityId);
      await FetchUsers().call(); // TODO Switch to listen by Community ID
      final community = GetCommunityById().call(communityId);
      final user = GetUser().call(userId);

      await _sessionService.startWatchers(userId: userId, communityId: community.id);

      emit(FormSubmittedSuccessfully(community: community, user: user));
    } catch (e, s) {
      _logger.logException(
        exception: e,
        featureArea: 'OnboardingCommunityRegistrationCubit.submit',
        stackTrace: s,
        metadata: _formState.toMap(),
      );
      emit(ErrorState());
    }
  }
}
