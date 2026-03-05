import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'payment_details_state.dart';
import 'package:resipal_core/lib.dart';

class PaymentDetailsCubit extends Cubit<PaymentDetailsState> {
  final LoggerService _logger = GetIt.I<LoggerService>();

  final WatchPaymentById _watchPaymentById = WatchPaymentById();
  StreamSubscription? _streamSubscription;

  PaymentDetailsCubit() : super(InitialState());

  Future initialize(PaymentEntity payment) async {
    try {
      emit(LoadedState(payment));

      _streamSubscription = _watchPaymentById
          .call(payment.id)
          .listen(
            (payment) async {
              emit(LoadedState(payment));
            },
            onError: (e, s) {
              _logger.logException(
                featureArea: 'PaymentDetailsCubit.initialize',
                exception: e,
                stackTrace: s,
                metadata: {'payment': payment.toMap()},
              );

              emit(ErrorState());
            },
          );
    } catch (e, s) {
      _logger.logException(
        exception: e,
        featureArea: 'PaymentDetailsCubit.initialize',
        stackTrace: s,
        metadata: {'payment': payment.toMap()},
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
