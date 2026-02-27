import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:resipal_admin/admin_session_service.dart';
import 'package:resipal_admin/presentation/applications/list/application_list_state.dart';
import 'package:resipal_core/lib.dart';

class ApplicationListCubit extends Cubit<ApplicationListState> {
  final LoggerService _logger = GetIt.I<LoggerService>();
  final AdminSessionService _sessionService = GetIt.I<AdminSessionService>();

  final WatchApplicationsByCommunity _watchApplicationsByCommunity = WatchApplicationsByCommunity();
  StreamSubscription? _streamSubscription;

  ApplicationListCubit() : super(InitialState());

  Future initialize() async {
    final communityId = _sessionService.communityId;

    try {
      emit(LoadingState());

      _streamSubscription = _watchApplicationsByCommunity
          .call(communityId)
          .listen(
            (applications) async {
              emit(LoadedState(applications));
            },
            onError: (e, s) {
              _logger.logException(
                featureArea: 'ApplicationListCubit.initialize',
                exception: e,
                stackTrace: s,
                metadata: {'communityId': communityId},
              );

              emit(ErrorState());
            },
          );
    } catch (e, s) {
      _logger.logException(
        exception: e,
        featureArea: 'ApplicationListCubit.initialize',
        stackTrace: s,
        metadata: {'communityId': communityId},
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
