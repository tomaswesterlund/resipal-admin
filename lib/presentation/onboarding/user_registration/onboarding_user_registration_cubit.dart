import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:resipal_admin/presentation/onboarding/user_registration/onboarding_user_registration_form_state.dart';
import 'package:resipal_admin/presentation/onboarding/user_registration/onboarding_user_registration_state.dart';
import 'package:resipal_core/lib.dart';

class OnboardingUserRegistrationCubit extends Cubit<OnboardingUserRegistrationState> {
  final LoggerService _logger = GetIt.I<LoggerService>();
  final AuthService _authService = GetIt.I<AuthService>();

  OnboardingUserRegistrationCubit() : super(InitialState());

  OnboardingUserRegistrationFormState _formState = OnboardingUserRegistrationFormState();

  void initialize() {
    try {
      final user = _authService.getSignedInUser();
      _formState = _formState.copyWith(email: user.email);
      emit(FormEditingState(_formState));
    } catch (e, s) {
      _logger.logException(
        exception: e,
        featureArea: 'OnboardingRegistrationCubit.initialize',
        stackTrace: s,
        metadata: _formState.toMap(),
      );
      emit(ErrorState());
    }
  }

  void onNameChanged(String newName) {
    _formState = _formState.copyWith(name: newName);
    emit(FormEditingState(_formState));
  }

  void onPhoneChanged(String newPhoneNumber) {
    _formState = _formState.copyWith(phoneNumber: newPhoneNumber);
    emit(FormEditingState(_formState));
  }

  Future<void> submit() async {
    try {
      if (_formState.canSubmit == false) {
        return;
      }

      emit(FormSubmittingState());
      final userId = await CreateUser().call(
        name: _formState.name,
        phoneNumber: _formState.phoneNumber,
        email: _formState.email,
      );

      await FetchUser().call(userId);

      emit(FormSubmittedSuccessfully());
    } catch (e, s) {
      _logger.logException(
        exception: e,
        featureArea: 'OnboardingRegistrationCubit.submit',
        stackTrace: s,
        metadata: _formState.toMap(),
      );
      emit(ErrorState());
    }
  }
}
