import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:resipal_admin/admin_session_service.dart';
import 'package:resipal_admin/presentation/home/overview/home_overview_state.dart';
import 'package:resipal_core/lib.dart';

class HomeOverviewCubit extends Cubit<HomeOverviewState> {
  final AuthService _authService = GetIt.I<AuthService>();
  final LoggerService _logger = GetIt.I<LoggerService>();
  final AdminSessionService _sessionService = GetIt.I<AdminSessionService>();

  final WatchCommunityById _watchCommunityById = WatchCommunityById();
  StreamSubscription? _streamSubscription;

  HomeOverviewCubit() : super(InitialState());

  Future<void> initialize() async {
    try {
      emit(LoadingState());

      final communityId = _sessionService.communityId;
      final userId = _authService.getSignedInUserId();
      final member = GetMemberByUserAndCommunityId().call(communityId: communityId, userId: userId);

      _streamSubscription = _watchCommunityById
          .call(communityId: communityId)
          .listen(
            (community) {
              emit(LoadedState(community: community, member: member));
            },
            onError: (e, s) {
              _logger.logException(exception: e, stackTrace: s, featureArea: 'HomeOverviewCubit.initialize / listener');
              emit(ErrorState());
            },
          );
    } catch (e, s) {
      _logger.logException(exception: e, stackTrace: s, featureArea: 'HomeOverviewCubit.initialize');
      emit(ErrorState());
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
