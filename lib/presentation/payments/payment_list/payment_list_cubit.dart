import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:resipal_admin/admin_session_service.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';
import 'payment_list_state.dart';

enum PaymentFilter { all, confirmed, pendingReview }

class PaymentListCubit extends Cubit<PaymentListState> {
  final WatchPaymentsByCommunity _watchPayments = WatchPaymentsByCommunity();
  final LoggerService _logger = GetIt.I<LoggerService>();
  final AdminSessionService _sessionService = GetIt.I();

  StreamSubscription? _subscription;

  final List<FilterSelectorItem> filterItems = [
    FilterSelectorItem(label: 'Todos', value: PaymentFilter.all),
    FilterSelectorItem(label: 'Confirmados', value: PaymentFilter.confirmed),
    FilterSelectorItem(label: 'En revisión', value: PaymentFilter.pendingReview),
  ];

  late FilterSelectorItem selectedFilter;
  late List<PaymentEntity> allPayments;

  PaymentListCubit() : super(InitialState());

  void initialize() {
    emit(LoadingState());
    _subscription?.cancel();

    selectedFilter = filterItems.first;

    _subscription = _watchPayments
        .call(_sessionService.communityId)
        .listen(
          (payments) {
            if (payments.isEmpty) {
              emit(EmptyState());
            } else {
              payments.sort((a, b) => b.date.compareTo(a.date));
              allPayments = payments;
              emit(LoadedState(payments, filterItems, selectedFilter));
            }
          },
          onError: (e, s) {
            _logger.logException(exception: e, stackTrace: s, featureArea: 'PaymentListCubit.initialize');
            emit(ErrorState());
          },
        );
  }

  void onFilterChanged(FilterSelectorItem newFilter) {
    selectedFilter = newFilter;
    var payments = allPayments;

    if (newFilter.value == PaymentFilter.confirmed) {
      payments = allPayments.where((x) => x.status == PaymentStatus.approved).toList();
    }

    if (newFilter.value == PaymentFilter.pendingReview) {
      payments = allPayments.where((x) => x.status == PaymentStatus.pendingReview).toList();
    }

    payments.sort((a, b) => b.date.compareTo(a.date));

    emit(LoadedState(payments, filterItems, newFilter));
    return;
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
