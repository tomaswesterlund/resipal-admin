import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:resipal_admin/presentation/communities/community_details/community_details_state.dart';
import 'package:resipal_core/lib.dart';

class CommunityDetailsCubit extends Cubit<CommunityDetailsState> {
  final LoggerService _logger = GetIt.I<LoggerService>();

  CommunityDetailsCubit() : super(InitialState());

  final WatchCommunityById _watchCommunityById = WatchCommunityById();
  StreamSubscription? _streamSubscription;

  void initialize(CommunityEntity community) {
    try {
      emit(LoadedState(community));

      _watchCommunityById
          .call(communityId: community.id)
          .listen(
            (community) => emit(LoadedState(community)),
            onError: (e, s) {
              _logger.logException(featureArea: 'WatchCommunityById.onError', exception: e, stackTrace: s);
              emit(ErrorState());
            },
          );
    } catch (e, s) {
      _logger.logException(featureArea: 'WatchCommunityById.initialize', exception: e, stackTrace: s);
      emit(ErrorState());
    }
  }


@override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
  
}
