import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:resipal_admin/admin_session_service.dart';
import 'package:resipal_admin/presentation/payments/confirm_payment/confirm_payment_state.dart';
import 'package:resipal_core/domain/entities/payment/payment_entity.dart';
import 'package:resipal_core/domain/use_cases/payments/confirm_payment_received.dart';
import 'package:resipal_core/domain/use_cases/payments/fetch_payment_by_id.dart';
import 'package:resipal_core/domain/use_cases/payments/watch_payment_by_id.dart';
import 'package:resipal_core/services/logger_service.dart';

class ConfirmPaymentCubit extends Cubit<ConfirmPaymentState> {
  final LoggerService _logger = GetIt.I<LoggerService>();
  final AdminSessionService _sessionService = GetIt.I<AdminSessionService>();

  ConfirmPaymentCubit() : super(InitialState());

  void initialize(String paymentId) {
    try {
      emit(LoadingState());

      WatchPaymentById()
          .call(paymentId)
          .listen(
            (payment) {
              emit(LoadedState(payment));
            },
            onError: (e, s) {
              _logger.logException(
                exception: e,
                featureArea: 'ConfirmPaymentCubit.',
                stackTrace: s,
                metadata: {'paymentId': paymentId},
              );
              emit(ErrorState());
            },
          );
    } catch (e, s) {
      _logger.logException(
        exception: e,
        featureArea: 'ConfirmPaymentCubit.',
        stackTrace: s,
        metadata: {'paymentId': paymentId},
      );
      emit(ErrorState());
    }
  }

  Future submit(PaymentEntity payment) async {
    try {
      await ConfirmPaymentReceived().call(
        communityId: _sessionService.communityId,
        paymentId: payment.id,
        userId: payment.user.id,
      );
      final updatedPayment = await FetchPaymentById().call(payment.id);
      emit(LoadedState(updatedPayment));
    } catch (e, s) {
      _logger.logException(
        exception: e,
        featureArea: 'PaymentDetailsCubit.confirmPaymentReceived',
        stackTrace: s,
        metadata: payment.toMap(),
      );
    }
  }
}
