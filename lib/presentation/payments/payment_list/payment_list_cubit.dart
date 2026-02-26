import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:resipal_admin/admin_session_service.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';
import 'payment_list_state.dart';

class PaymentListCubit extends Cubit<PaymentListState> {
  final WatchPaymentsByCommunity _watchPayments = WatchPaymentsByCommunity();
  final LoggerService _logger = GetIt.I<LoggerService>();
  final AdminSessionService _sessionService = GetIt.I();

  StreamSubscription? _subscription;

  final List<FilterSelectorItem> selectorItems = [
    FilterSelectorItem(label: 'Todos', value: 'todos'),
    FilterSelectorItem(label: 'Pagados', value: 'pagados'),
    FilterSelectorItem(label: 'En revisíon', value: 'revision'),
  ];

  late FilterSelectorItem selector;
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

  void onSelectorChanged(FilterSelectorItem newSelector) {
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
