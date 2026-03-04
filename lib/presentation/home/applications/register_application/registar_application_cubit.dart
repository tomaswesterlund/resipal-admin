import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:resipal_admin/admin_session_service.dart';
import 'package:resipal_core/lib.dart';
import 'register_application_state.dart';
import 'register_application_form_state.dart';

class RegisterApplicationCubit extends Cubit<RegisterApplicationState> {
  final AdminSessionService _sessionService = GetIt.I<AdminSessionService>();
  final LoggerService _logger = GetIt.I<LoggerService>();

  RegisterApplicationCubit() : super(InitialState());

  late RegisterApplicationFormState _formState;

  void initialize() {
    _formState = const RegisterApplicationFormState();
    emit(FormEditingState(_formState));
  }

  void updateName(String val) => _update(() => _formState.copyWith(name: val));
  void updateEmail(String val) => _update(() => _formState.copyWith(email: val));
  void updatePhone(String val) => _update(() => _formState.copyWith(phoneNumber: val));
  void updateEmergencyPhone(String val) => _update(() => _formState.copyWith(emergencyPhoneNumber: val));
  void updateMessage(String val) => _update(() => _formState.copyWith(message: val));

  void toggleAdmin(bool? val) => _update(() => _formState.copyWith(isAdmin: val));
  void toggleResident(bool? val) => _update(() => _formState.copyWith(isResident: val));
  void toggleSecurity(bool? val) => _update(() => _formState.copyWith(isSecurity: val));

  void _update(RegisterApplicationFormState Function() next) {
    _formState = next();
    emit(FormEditingState(_formState));
  }

  Future<void> submit() async {
    if (state is! FormEditingState || !_formState.canSubmit) return;

    emit(FormSubmittingState());

    try {
      final dto = CreateApplicationDto(
        communityId: _sessionService.communityId,
        userId: null,
        name: _formState.name,
        email: _formState.email,
        phoneNumber: _formState.phoneNumber,
        emergencyPhoneNumber: _formState.emergencyPhoneNumber,
        status: ApplicationStatus.invited.toString(),
        message: _formState.message,
        isAdmin: _formState.isAdmin,
        isResident: _formState.isResident,
        isSecurity: _formState.isSecurity,
      );

      await CreateApplication().call(dto);

      emit(FormSubmittedSuccessfullyState());
    } catch (e, s) {
      await _logger.logException(exception: e, stackTrace: s, featureArea: 'RegisterApplicationCubit.submit');
      emit(ErrorState());
    }
  }
}
