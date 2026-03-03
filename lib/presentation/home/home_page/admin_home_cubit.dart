import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:resipal_admin/presentation/home/home_page/admin_home_state.dart';
import 'package:resipal_core/lib.dart';

class AdminHomeCubit extends Cubit<AdminHomeState> {
  final LoggerService _logger = GetIt.I<LoggerService>();
  final WatchCommunityById _watchCommunityById = WatchCommunityById();
  StreamSubscription? _streamSubscription;

  AdminHomeCubit() : super(InitialState());

  Future<void> initialize(CommunityEntity community) async {
    try {
      emit(LoadedState(community));

      _streamSubscription = _watchCommunityById
          .call(communityId: community.id)
          .listen(
            (community) {
              emit(LoadedState(community));
            },
            onError: (e, s) {
              _logger.logException(exception: e, stackTrace: s, featureArea: 'AdminHomeCubit.initialize / listener');
              emit(ErrorState());
            },
          );
    } catch (e, s) {
      _logger.logException(exception: e, stackTrace: s, featureArea: 'AdminHomeCubit.initialize');
      emit(ErrorState());
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
