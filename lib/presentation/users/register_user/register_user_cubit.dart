import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:resipal_admin/presentation/users/register_user/register_user_form_state.dart';
import 'package:resipal_admin/presentation/users/register_user/register_user_state.dart';
import 'package:resipal_core/lib.dart';

class RegisterUserCubit extends Cubit<RegisterUserState> {
  final LoggerService _logger = GetIt.I<LoggerService>();

  RegisterUserCubit() : super(InitialState());

  RegisterUserFormState _formState = RegisterUserFormState();

  void initialize() {
    emit(FormEditingState(_formState));
  }

  void updateName(String newName) {
    _formState = _formState.copyWith(name: newName);
    emit(FormEditingState(_formState));
  }

  void updateEmail(String newEmail) {
    _formState = _formState.copyWith(email: newEmail);
    emit(FormEditingState(_formState));
  }

  void updatePhoneNumber(String newPhoneNumber) {
    _formState = _formState.copyWith(phoneNumber: newPhoneNumber);
    emit(FormEditingState(_formState));
  }

  void updateEmergencyPhoneNumber(String newEmergencyPhoneNumber) {
    _formState = _formState.copyWith(emergencyPhoneNumber: newEmergencyPhoneNumber);
    emit(FormEditingState(_formState));
  }

  void updateIsAdmin(bool? newValue) {
    _formState = _formState.copyWith(isAdmin: newValue);
    emit(FormEditingState(_formState));
  }

  void updateIsResident(bool? newValue) {
    _formState = _formState.copyWith(isResident: newValue);
    emit(FormEditingState(_formState));
  }

  void updateIsSecurity(bool? newValue) {
    _formState = _formState.copyWith(isSecuriy: newValue);
    emit(FormEditingState(_formState));
  }

  Future submit() async {
    try {
      if (_formState.canSubmit == false) {
        emit(ErrorState());
        return;
      }

      emit(FormSubmittingState());
      await CreateUser().call(
        name: _formState.name!,
        phoneNumber: _formState.phoneNumber!,
        emergencyPhoneNumber: _formState.emergencyPhoneNumber,
        email: _formState.email!,
        status: ApplicationStatus.approved,
        applicationMessage: 'Invitación enviado por la administración.',
        isAdmin: _formState.isAdmin,
        isResident: _formState.isResident,
        isSecurity: _formState.isSecuriy,
      );

      emit(FormSubmittedSuccessfullyState());
    } catch (e, s) {
      await _logger.logException(
        exception: e,
        stackTrace: s,
        featureArea: 'RegisterPropertyCubit.submit',
        metadata: _formState.toMap(),
      );
      emit(ErrorState());
    }
  }
}
