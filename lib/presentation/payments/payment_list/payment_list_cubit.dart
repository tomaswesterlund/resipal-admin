import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:resipal_admin/admin_session_service.dart';
import 'package:resipal_admin/shared/dynamic_selector.dart';
import 'package:resipal_core/domain/entities/payment/payment_entity.dart';
import 'package:resipal_core/domain/enums/payment_status.dart';
import 'package:resipal_core/domain/use_cases/payments/watch_payments_by_community.dart';
import 'package:resipal_core/services/logger_service.dart';
import 'payment_list_state.dart';

class PaymentListCubit extends Cubit<PaymentListState> {
  final WatchPaymentsByCommunity _watchPayments = WatchPaymentsByCommunity();
  final LoggerService _logger = GetIt.I<LoggerService>();
  final AdminSessionService _sessionService = GetIt.I();

  StreamSubscription? _subscription;

  final List<DynamicSelectorItem> selectorItems = [
    DynamicSelectorItem(label: 'Todos', value: 'todos'),
    DynamicSelectorItem(label: 'Pagados', value: 'pagados'),
    DynamicSelectorItem(label: 'En revisíon', value: 'revision'),
  ];

  late DynamicSelectorItem selector;
  late List<PaymentEntity> allPayments;

  PaymentListCubit() : super(InitialState());

  void initialize() {
    emit(LoadingState());
    _subscription?.cancel();

    selector = selectorItems.first;

    _subscription = _watchPayments
        .call(_sessionService.communityId)
        .listen(
          (payments) {
            if (payments.isEmpty) {
              emit(EmptyState());
            } else {
              allPayments = payments;
              emit(LoadedState(payments, selectorItems, selector));
            }
          },
          onError: (e, s) {
            _logger.logException(exception: e, stackTrace: s, featureArea: 'PaymentListCubit.initialize');
            emit(ErrorState());
          },
        );
  }

  void onSelectorChanged(DynamicSelectorItem newSelector) {
    selector = newSelector;

    // Filter
    if (newSelector.value == 'todos') {
      emit(LoadedState(allPayments, selectorItems, newSelector));
      return;
    }

    if (newSelector.value == 'pagados') {
      final filtered = allPayments.where((x) => x.status == PaymentStatus.approved).toList();
      emit(LoadedState(filtered, selectorItems, newSelector));
      return;
    }

    if (newSelector.value == 'revision') {
      final filtered = allPayments.where((x) => x.status == PaymentStatus.pendingReview).toList();
      emit(LoadedState(filtered, selectorItems, newSelector));
      return;
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
