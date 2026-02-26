import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:resipal_admin/admin_session_service.dart';
import 'payment_details_state.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';

class PaymentDetailsCubit extends Cubit<PaymentDetailsState> {
  final LoggerService _logger = GetIt.I<LoggerService>();
  final AdminSessionService _sessionService = GetIt.I<AdminSessionService>();

  final WatchPaymentById _watchPaymentById = WatchPaymentById();
  StreamSubscription? _streamSubscription;

  PaymentDetailsCubit() : super(InitialState());

  Future initialize(String paymentId) async {
    try {
      emit(LoadingState());

      _streamSubscription = _watchPaymentById
          .call(paymentId)
          .listen(
            (payment) {
              emit(LoadedState(payment));
            },
            onError: (e, s) {
              _logger.logException(
                featureArea: 'PaymentDetailsCubit.initialize',
                exception: e,
                stackTrace: s,
                metadata: {'paymentId': paymentId},
              );

              emit(ErrorState());
            },
          );
    } catch (e, s) {
      _logger.logException(
        exception: e,
        featureArea: 'PaymentDetailsCubit.initialize',
        stackTrace: s,
        metadata: {'paymentId': paymentId},
      );

      emit(ErrorState());
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
