import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:resipal_admin/admin_session_service.dart';
import 'package:resipal_core/domain/use_cases/contracts/create_contract.dart';
import 'package:resipal_core/domain/use_cases/contracts/fetch_contract.dart';
import 'package:resipal_core/helpers/formatters/currency_formatter.dart';
import 'package:resipal_core/services/logger_service.dart';
import 'register_contract_state.dart';
import 'register_contract_form_state.dart';

class RegisterContractCubit extends Cubit<RegisterContractState> {
  final AdminSessionService _sessionService = GetIt.I<AdminSessionService>();
  final LoggerService _logger = GetIt.I<LoggerService>();

  RegisterContractCubit() : super(FormEditingState(const RegisterContractFormState()));

  void updateName(String val) {
    if (state is FormEditingState) {
      final current = (state as FormEditingState).formState;
      emit(FormEditingState(current.copyWith(name: val)));
    }
  }

  void updateAmount(String val) {
    if (state is FormEditingState) {
      final current = (state as FormEditingState).formState;
      final doubleAmount = double.tryParse(val) ?? 0.0;
      emit(FormEditingState(current.copyWith(amount: doubleAmount)));
    }
  }

  void updateDescription(String val) {
    if (state is FormEditingState) {
      final current = (state as FormEditingState).formState;
      emit(FormEditingState(current.copyWith(description: val)));
    }
  }

  Future submit() async {
    if (state is! FormEditingState) return;
    final form = (state as FormEditingState).formState;
    if (!form.canSubmit) return;

    emit(FormSubmittingState());
    try {
      final contractId = await CreateContract().call(
        communityId: _sessionService.communityId,
        name: form.name,
        amountInCents: CurrencyFormatter.toAmountInCents(form.amount),
        period: 'monthly',
        description: form.description,
      );

      await FetchContract().call(contractId);


      emit(FormSubmittedSuccessfullyState());
    } catch (e, s) {
      emit(ErrorState());
      _logger.logException(
        exception: e,
        stackTrace: s,
        featureArea: 'RegisterContractCubit.submit',
      );
    }
  }
}
